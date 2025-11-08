import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:kasirsuper/features/product/models/product_model.dart';

class ProductBarcodeDialog extends StatelessWidget {
  final ProductModel product;

  const ProductBarcodeDialog({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.dp16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.dp24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            HeadingText(
              'Produk Berhasil Dibuat!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: Dimens.dp20,
              ),
            ),
            const SizedBox(height: 8),
            RegularText(
              product.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimens.dp16,
                color: context.theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            if (product.barcode != null) ...[
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth,
                    padding: const EdgeInsets.all(Dimens.dp16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Dimens.dp8),
                      border: Border.all(
                        color: context.theme.primaryColor.withAlpha((0.3 * 255).round()),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth - 32,
                              maxHeight: 100,
                            ),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: BarcodeWidget(
                                barcode: Barcode.code128(),
                                data: product.barcode!,
                                width: 250,
                                height: 80,
                                drawText: true,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              RegularText(
                'Barcode: ${product.barcode}',
                style: const TextStyle(
                  fontSize: Dimens.dp12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tutup'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement print functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur print dalam pengembangan'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.print),
                    label: const Text('Print'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to add another product
                  Navigator.pushReplacementNamed(
                    context,
                    '/product/form',
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah Produk Lagi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
