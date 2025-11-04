part of '../page.dart';

class _ItemSection extends StatelessWidget {
  const _ItemSection({required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                    transaction.status.name,
                    style: TextStyle(
                      fontSize: Dimens.dp10,
                      color: context.theme.primaryColor,
                    ),
                  ),
                ),
                RegularText.semiBold(
                  transaction.date.toString(),
                  style: const TextStyle(
                    fontSize: Dimens.dp10,
                  ),
                )
              ],
            ),
            Dimens.dp16.height,
            RegularText.semiBold(
              'TRX-${transaction.id}',
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
    );
  }
}
