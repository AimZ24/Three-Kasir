part of '../page.dart';

class _ItemSection extends StatelessWidget {
  const _ItemSection({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.defaultSize),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimens.dp8),
                child: product.imageUrl != null
                    ? Image.network(
                        product.imageUrl!,
                        width: 74,
                        height: 74,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 74,
                        height: 74,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image),
                      ),
              ),
              Dimens.dp12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RegularText.semiBold(product.name),
                    Dimens.dp8.height,
                    RegularText.semiBold(
                        'Rp ${product.price.toStringAsFixed(0)}'),
                  ],
                ),
              ),
            ],
          ),
          Dimens.dp18.height,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditProductPage(
                          product: product,
                        ),
                      ),
                    );
                  },
                  child: const Text('Edit'),
                ),
              ),
              Dimens.dp16.width,
              Expanded(
                child: OutlinedButton(
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
                          TextButton(
                            onPressed: () {
                              context
                                  .read<ProductBloc>()
                                  .add(DeleteProduct(product.id));
                              Navigator.pop(context);
                            },
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Delete'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
