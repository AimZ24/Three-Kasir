import 'package:kasirsuper/compat/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:kasirsuper/features/transaction/models/transaction_model.dart';

class PrinterService {
  static final PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  static PrinterBluetooth? _selectedPrinter;

  static Stream<List<PrinterBluetooth>> get scanResults => _printerManager.scanResults;

  static void startScan() {
    _printerManager.startScan(const Duration(seconds: 4));
  }

  static void stopScan() {
    _printerManager.stopScan();
  }

  static Future<bool> connect(PrinterBluetooth printer) async {
    try {
      _selectedPrinter = printer;
      return true;
    } catch (e) {
      debugPrint('Error connecting to printer: $e');
      return false;
    }
  }

  static Future<bool> disconnect() async {
    try {
      _selectedPrinter = null;
      return true;
    } catch (e) {
      debugPrint('Error disconnecting printer: $e');
      return false;
    }
  }

  static Future<bool> isConnected() async {
    return _selectedPrinter != null;
  }

  static Future<void> printReceipt(TransactionModel transaction) async {
    if (_selectedPrinter == null) {
      throw Exception('Printer not connected');
    }

    // Initialize the printer
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    // Generate receipt content
    List<int> bytes = [];

    // Header
    bytes += generator.text('KASIR SUPER',
        styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text('Transaction Receipt',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('================================',
        styles: const PosStyles(align: PosAlign.center));

    // Transaction info
    bytes += generator.text('Date: ${transaction.date}');
    bytes += generator.text('ID: TRX-${transaction.id}');
    bytes += generator.text('');

    // Items
    for (var item in transaction.items) {
      bytes += generator.text(item.product.name);
      bytes += generator.row([
        PosColumn(
          text: '${item.quantity}x @ ${item.product.price.toStringAsFixed(0)}',
          width: 6,
        ),
        PosColumn(
          text: 'Rp ${item.totalPrice.toStringAsFixed(0)}',
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    bytes += generator.text('--------------------------------');

    // Total
    bytes += generator.row([
      PosColumn(
        text: 'TOTAL',
        width: 6,
        styles: const PosStyles(bold: true),
      ),
      PosColumn(
        text: 'Rp ${transaction.total.toStringAsFixed(0)}',
        width: 6,
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ),
    ]);

    // Footer
    bytes += generator.text('');
    bytes += generator.text('Thank you for your purchase!',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.cut();

    // Send to printer
    _printerManager.selectPrinter(_selectedPrinter!);
    try {
      final result = await _printerManager.printTicket(bytes);
      if (result != true) {
        throw Exception('Failed to print receipt');
      }
    } catch (e) {
      throw Exception('Error printing receipt: $e');
    }
  }
}