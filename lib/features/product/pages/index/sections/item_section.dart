part of '../page.dart';

class _ItemSection extends StatelessWidget {
  const _ItemSection({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: Dimens.dp12),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.defaultSize),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimens.dp8),
                  child: product.imageUrl != null
                      ? Image.file(
                          File(product.imageUrl!),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, size: 40),
                            );
                          },
                        )
                      : Container(
                          width: 80,
                          height: 80,
                          color: context.theme.primaryColor.withAlpha((0.1 * 255).round()),
                          child: Icon(Icons.inventory_2, size: 40, color: context.theme.primaryColor),
                        ),
                ),
                Dimens.dp12.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: RegularText.semiBold(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildStatusChip(context),
                        ],
                      ),
                      Dimens.dp4.height,
                      if (product.barcode != null)
                        RegularText(
                          'Barcode: ${product.barcode}',
                          style: TextStyle(
                            fontSize: Dimens.dp12,
                            color: Colors.grey[600],
                          ),
                        ),
                      Dimens.dp8.height,
                      RegularText.semiBold(
                        'Rp ${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: Dimens.dp16,
                          color: context.theme.primaryColor,
                        ),
                      ),
                      if (product.trackStock) ...[
                        Dimens.dp4.height,
                        Row(
                          children: [
                            Icon(
                              Icons.inventory,
                              size: 16,
                              color: product.isLowStock ? Colors.orange : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            RegularText(
                              'Stok: ${product.stock}',
                              style: TextStyle(
                                fontSize: Dimens.dp12,
                                color: product.isLowStock ? Colors.orange : Colors.grey[700],
                                fontWeight: product.isLowStock ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                            if (product.isLowStock) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withAlpha((0.2 * 255).round()),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'STOK MENIPIS',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            Dimens.dp12.height,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showBarcodeDialog(context);
                    },
                    icon: const Icon(Icons.qr_code_2, size: 16),
                    label: const Text('View', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditProductPage(
                            product: product,
                          ),
                        ),
                      );
                      if (context.mounted) {
                        context.read<ProductBloc>().add(LoadProducts());
                      }
                    },
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Hapus Produk'),
                          content: Text(
                              'Yakin ingin menghapus produk "${product.name}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Batal'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<ProductBloc>()
                                    .add(DeleteProduct(product.id));
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('Hapus', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBarcodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header (Fixed)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Detail Produk',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: context.theme.primaryColor,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                
                // Product Image
                if (product.imageUrl != null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(product.imageUrl!),
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.image, size: 60),
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                
                // Product Name
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Product Price
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: context.theme.primaryColor.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.payments,
                        size: 20,
                        color: context.theme.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Rp ${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Stock Info
                if (product.trackStock) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.inventory,
                        size: 20,
                        color: product.isLowStock ? Colors.orange : Colors.grey[700],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Stok: ${product.stock}',
                        style: TextStyle(
                          fontSize: 14,
                          color: product.isLowStock ? Colors.orange : Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (product.isLowStock) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withAlpha((0.2 * 255).round()),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'STOK MENIPIS',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                
                // Status
                Row(
                  children: [
                    const Icon(Icons.info_outline, size: 20),
                    const SizedBox(width: 8),
                    const Text('Status: ', style: TextStyle(fontSize: 14)),
                    _buildStatusChip(context),
                  ],
                ),
                
                // Barcode Section
                if (product.barcode != null) ...[
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Barcode Produk',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: context.theme.primaryColor,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _printBarcode(context, product);
                        },
                        icon: const Icon(Icons.print, size: 18),
                        label: const Text('Print'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        width: constraints.maxWidth,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Center(
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
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      product.barcode!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.qr_code_2, color: Colors.grey[600]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Produk ini belum memiliki barcode',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                // Description
                if (product.description != null && product.description!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color chipColor;
    IconData chipIcon;
    String chipLabel;

    switch (product.status) {
      case ProductStatus.active:
        chipColor = Colors.green;
        chipIcon = Icons.check_circle;
        chipLabel = 'Aktif';
        break;
      case ProductStatus.inactive:
        chipColor = Colors.red;
        chipIcon = Icons.cancel;
        chipLabel = 'Nonaktif';
        break;
      case ProductStatus.outOfStock:
        chipColor = Colors.orange;
        chipIcon = Icons.inventory_2;
        chipLabel = 'Habis';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withAlpha((0.2 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(chipIcon, size: 14, color: chipColor),
          const SizedBox(width: 4),
          Text(
            chipLabel,
            style: TextStyle(
              fontSize: 11,
              color: chipColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _printBarcode(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.print, color: context.theme.primaryColor),
            const SizedBox(width: 12),
            const Text('Print Barcode'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  // Nama Produk di atas
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  // Barcode di tengah
                  BarcodeWidget(
                    barcode: Barcode.code128(),
                    data: product.barcode!,
                    width: 250,
                    height: 80,
                    drawText: false, // Text manual di bawah
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // ID Barcode di bawah
                  Text(
                    product.barcode!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Fitur print akan tersedia setelah integrasi printer.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement actual print functionality
              Navigator.pop(context);
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
        ],
      ),
    );
  }
}
