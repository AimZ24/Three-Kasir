part of '../page.dart';

class _ItemSection extends StatelessWidget {
  const _ItemSection({required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: Dimens.dp12),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            TransactionDetailPage.routeName,
            arguments: transaction,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(Dimens.dp16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimens.dp4,
                      horizontal: Dimens.dp12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimens.dp4),
                      border: Border.all(
                        color: context.theme.primaryColor,
                      ),
                    ),
                    child: RegularText.semiBold(
                      transaction.status.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: Dimens.dp10,
                        color: context.theme.primaryColor,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      RegularText.semiBold(
                        transaction.date.toString(),
                        style: const TextStyle(
                          fontSize: Dimens.dp10,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        color: Colors.red,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Hapus Transaksi'),
                              content: Text(
                                  'Yakin ingin menghapus transaksi ${transaction.id}?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: const Text('Batal'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<TransactionBloc>()
                                        .add(DeleteTransaction(transaction.id));
                                    Navigator.pop(dialogContext);
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
                      ),
                    ],
                  ),
                ],
              ),
              Dimens.dp16.height,
              RegularText.semiBold(
                transaction.id,
              ),
              Dimens.dp8.height,
              RegularText.semiBold(
                'Rp ${transaction.total.toStringAsFixed(0)}',
                style: TextStyle(
                  color: context.theme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
