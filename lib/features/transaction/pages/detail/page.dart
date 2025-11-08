import 'package:flutter/material.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:kasirsuper/features/transaction/models/transaction_model.dart';
import 'package:kasirsuper/features/settings/services/printer_service.dart';

class TransactionDetailPage extends StatelessWidget {
  static const routeName = '/transaction_detail';

  const TransactionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final TransactionModel? transaction = args is TransactionModel ? args : null;

    if (transaction == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Transaksi')),
        body: const Center(child: RegularText('Transaction data not provided')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () async {
              try {
                await PrinterService.printReceipt(transaction);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Printing started')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to print: $e')),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.defaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(Dimens.dp16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SubtitleText('ID Transaksi'),
                        SubtitleText(
                          transaction.id,
                          style: TextStyle(
                            color: context.theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    RegularText('Tanggal: ${transaction.date}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            Expanded(
              child: ListView.separated(
                itemCount: transaction.items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = transaction.items[index];
                  return ListTile(
                    title: Text(item.product.name),
                    subtitle: Text('${item.quantity} x Rp ${item.product.price.toStringAsFixed(0)}'),
                    trailing: Text('Rp ${item.totalPrice.toStringAsFixed(0)}'),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SubtitleText('TOTAL'),
                SubtitleText('Rp ${transaction.total.toStringAsFixed(0)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
