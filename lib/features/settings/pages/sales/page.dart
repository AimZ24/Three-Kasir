import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:kasirsuper/features/transaction/data/transaction_storage.dart';
import 'package:kasirsuper/features/transaction/models/transaction_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:kasirsuper/utils/download_helper.dart';

class SalesDataPage extends StatefulWidget {
  const SalesDataPage({super.key});
  static const String routeName = '/settings/sales';

  @override
  State<SalesDataPage> createState() => _SalesDataPageState();
}

class _SalesDataPageState extends State<SalesDataPage> {
  List<TransactionModel> _transactions = [];
  bool _loading = true;
  String _mode = 'monthly'; // 'weekly', 'monthly' or 'range'
  DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final tx = await TransactionLocalStorage.getTransactions();
    setState(() {
      _transactions = tx;
      _loading = false;
    });
  }

  Map<String, double> _aggregate() {
    final Map<String, double> map = {};
    final now = DateTime.now();
    if (_mode == 'weekly') {
      for (int i = 6; i >= 0; i--) {
        final d = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
        final key = DateFormat('yyyy-MM-dd').format(d);
        map[key] = 0.0;
      }
      for (final t in _transactions) {
        final dateKey = DateFormat('yyyy-MM-dd').format(DateTime(t.date.year, t.date.month, t.date.day));
        if (map.containsKey(dateKey)) {
          map[dateKey] = map[dateKey]! + t.total;
        }
      }
    } else if (_mode == 'range' && _range != null) {
      final start = _range!.start;
      final end = _range!.end.add(const Duration(days: 1));
      for (final t in _transactions) {
        if (t.date.isAfter(start.subtract(const Duration(seconds: 1))) && t.date.isBefore(end)) {
          final key = DateFormat('yyyy-MM-dd').format(t.date);
          map[key] = (map[key] ?? 0) + t.total;
        }
      }
    } else {
      for (int i = 5; i >= 0; i--) {
        final d = DateTime(now.year, now.month - i, 1);
        final key = DateFormat('yyyy-MM').format(d);
        map[key] = 0.0;
      }
      for (final t in _transactions) {
        final key = DateFormat('yyyy-MM').format(t.date);
        if (map.containsKey(key)) {
          map[key] = map[key]! + t.total;
        }
      }
    }
    return map;
  }

  Future<void> _exportXlsx() async {
    // Build filtered transactions according to mode
    List<TransactionModel> filtered;
    if (_mode == 'weekly') {
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day).subtract(Duration(days: 6));
      filtered = _transactions.where((t) => t.date.isAfter(start.subtract(const Duration(seconds: 1))) && t.date.isBefore(now.add(const Duration(days: 1)))).toList();
    } else if (_mode == 'range' && _range != null) {
      final start = _range!.start;
      final end = _range!.end.add(const Duration(days: 1));
      filtered = _transactions.where((t) => t.date.isAfter(start.subtract(const Duration(seconds: 1))) && t.date.isBefore(end)).toList();
    } else {
      final now = DateTime.now();
      filtered = _transactions.where((t) => t.date.year == now.year && t.date.month == now.month).toList();
    }

    // Fallback: create CSV content but save with .xlsx extension so it opens in Excel.
    final sb = StringBuffer();
    sb.writeln('Tanggal,Produk,Jumlah,Harga,Total');
    for (final t in filtered) {
      for (final item in t.items) {
        final prod = item.product.name.replaceAll(',', ' ');
        sb.writeln('${DateFormat('yyyy-MM-dd').format(t.date)},$prod,${item.quantity},${item.product.price},${(item.quantity * item.product.price).toStringAsFixed(0)}');
      }
    }

    try {
      Directory? targetDir;
      final status = await Permission.storage.request();
      if (status.isGranted) {
        try {
          if (Platform.isAndroid) {
            final dir = Directory('/storage/emulated/0/Download');
            if (await dir.exists()) {
              targetDir = dir;
            }
          }
        } catch (_) {
          targetDir = null;
        }
      }

      if (targetDir == null) {
        // fallback to app documents
        targetDir = await getApplicationDocumentsDirectory();
      }

      final now = DateTime.now();
      final fileName = 'sales_export_${_mode}_${DateFormat('yyyyMMdd_HHmmss').format(now)}.xlsx';
      final content = sb.toString();
      if (kIsWeb) {
        // trigger web download
        final bytes = utf8.encode(content);
        try {
          await downloadFile(fileName, bytes);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Download dimulai')));
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mendownload: $e')));
        }
      } else {
        final file = File('${targetDir.path}/$fileName');
        await file.writeAsString(content);
        // share the file so user sees it / can open it immediately
        try {
          await Share.shareXFiles([XFile(file.path)], text: 'Export data penjualan');
        } catch (_) {
          // fallback: show path saved
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export tersimpan: ${file.path}')));
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mengekspor XLSX: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
  final data = _aggregate();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Penjualan'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(Dimens.dp16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: Dimens.dp8,
                    runSpacing: Dimens.dp8,
                    children: [
                      ChoiceChip(
                        label: const Text('Bulanan'),
                        selected: _mode == 'monthly',
                        onSelected: (_) => setState(() => _mode = 'monthly'),
                      ),
                      ChoiceChip(
                        label: const Text('Mingguan'),
                        selected: _mode == 'weekly',
                        onSelected: (_) => setState(() => _mode = 'weekly'),
                      ),
                      ChoiceChip(
                        label: const Text('Range'),
                        selected: _mode == 'range',
                        onSelected: (_) => setState(() => _mode = 'range'),
                      ),
                      if (_mode == 'range')
                        ElevatedButton.icon(
                          onPressed: () async {
                            final picked = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) setState(() => _range = picked);
                          },
                          icon: const Icon(Icons.date_range),
                          label: Text(_range == null ? 'Pilih Range' : '${DateFormat('yyyy-MM-dd').format(_range!.start)} → ${DateFormat('yyyy-MM-dd').format(_range!.end)}'),
                        ),
                      ElevatedButton.icon(
                        onPressed: _exportXlsx,
                        icon: const Icon(Icons.download),
                        label: const Text('Export .xlsx'),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimens.dp16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimens.dp16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _mode == 'weekly' ? 'Grafik Penjualan (Mingguan)' : 'Grafik Penjualan (Bulanan)',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: Dimens.dp12),
                          SizedBox(
                            height: 160,
                            child: Builder(builder: (context) {
                              final labels = data.keys.toList();
                              final values = data.values.toList();
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: BarChartWidget(
                                  labels: labels,
                                  values: values,
                                  color: Theme.of(context).primaryColor,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimens.dp16),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(Dimens.dp12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Daftar Transaksi', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: Dimens.dp8),
                            Expanded(
                              child: _transactions.isEmpty
                                  ? const Center(child: Text('Tidak ada data penjualan'))
                                  : ListView.builder(
                                      itemCount: _transactions.length,
                                      itemBuilder: (context, index) {
                                        final t = _transactions[index];
                                        return ListTile(
                                          title: Text(DateFormat('yyyy-MM-dd – kk:mm').format(t.date)),
                                          subtitle: Text('${t.items.length} item - Rp ${t.total.toStringAsFixed(0)}'),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

/// A very small bar chart implemented with CustomPainter so we don't rely on
/// an external chart package. It accepts labels and values (same length).
class BarChartWidget extends StatelessWidget {
  final List<String> labels;
  final List<double> values;
  final Color color;

  const BarChartWidget({
    Key? key,
    required this.labels,
    required this.values,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BarChartPainter(labels: labels, values: values, color: color, textStyle: const TextStyle(fontSize: 10)),
      size: Size.infinite,
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<String> labels;
  final List<double> values;
  final Color color;
  final TextStyle textStyle;

  _BarChartPainter({required this.labels, required this.values, required this.color, required this.textStyle});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final paddingBottom = 28.0;
    final availableHeight = size.height - paddingBottom - 8.0;
    final maxValue = (values.isEmpty) ? 1.0 : values.reduce((a, b) => a > b ? a : b);
    final count = values.length == 0 ? 1 : values.length;
    final barWidth = (size.width / (count * 1.5)).clamp(6.0, 40.0);
    final gap = (size.width - (barWidth * count)) / (count + 1);

    for (var i = 0; i < values.length; i++) {
      final v = values[i];
      final left = gap + i * (barWidth + gap);
      final barHeight = (maxValue == 0) ? 0.0 : (v / maxValue) * availableHeight;
      final rect = Rect.fromLTWH(left, size.height - paddingBottom - barHeight, barWidth, barHeight);
      final r = RRect.fromRectAndRadius(rect, const Radius.circular(4));
      canvas.drawRRect(r, paint);

      // draw label
      final label = (labels.length > i) ? labels[i] : '';
  final tp = TextPainter(text: TextSpan(text: _shortLabel(label), style: textStyle.copyWith(color: Colors.black54)), textDirection: ui.TextDirection.ltr);
      tp.layout(minWidth: 0, maxWidth: barWidth + gap);
      final lx = left + (barWidth - tp.width) / 2;
      tp.paint(canvas, Offset(lx, size.height - paddingBottom + 4));
    }
  }

  String _shortLabel(String s) {
    // if label is yyyy-MM or yyyy-MM-dd, shorten for display
    if (RegExp(r"^\d{4}-\d{2}-\d{2}").hasMatch(s)) return s.substring(8);
    if (RegExp(r"^\d{4}-\d{2}").hasMatch(s)) return s.substring(5);
    if (s.length > 6) return s.substring(0, 6);
    return s;
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.labels != labels || oldDelegate.color != color;
  }
}
