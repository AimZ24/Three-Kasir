part of '../page.dart';

class _CartSection extends StatelessWidget {
  const _CartSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          left: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state.items.isEmpty) {
                  return const Center(
                    child: Text('Keranjang kosong'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(Dimens.defaultSize),
                  itemCount: state.items.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return Row(
                      children: [
                        // Product info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${item.product.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Quantity controls
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                context.read<CartBloc>().add(
                                      UpdateQuantity(
                                        productId: item.product.id,
                                        quantity: item.quantity - 1,
                                      ),
                                    );
                              },
                            ),
                            Text(
                              item.quantity.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                context.read<CartBloc>().add(
                                      UpdateQuantity(
                                        productId: item.product.id,
                                        quantity: item.quantity + 1,
                                      ),
                                    );
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          // Total and checkout section
          Container(
            padding: const EdgeInsets.all(Dimens.defaultSize),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rp ${state.total.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimens.dp16),
                    ElevatedButton(
                      onPressed: state.items.isEmpty
                          ? null
                          : () {
                              // TODO: Process checkout
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Checkout'),
                                  content: Text(
                                      'Total pembayaran: Rp ${state.total.toStringAsFixed(0)}'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        final transaction = TransactionModel(
                                          id: DateTime.now().toString(),
                                          date: DateTime.now(),
                                          items: state.items,
                                          total: state.total,
                                        );

                                        context
                                            .read<TransactionBloc>()
                                            .add(AddTransaction(transaction));
                                            
                                        context
                                            .read<CartBloc>()
                                            .add(ClearCart());
                                            
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Transaksi berhasil'),
                                          ),
                                        );
                                      },
                                      child: const Text('Bayar'),
                                    ),
                                  ],
                                ),
                              );
                            },
                      child: const Text('Checkout'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}