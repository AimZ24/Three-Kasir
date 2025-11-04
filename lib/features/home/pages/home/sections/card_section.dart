part of '../page.dart'; // Terkoneksi ke dalam main (dan di dalam main di koneksikan dengan part '')

class _CardSection extends StatelessWidget {
  const _CardSection({required this.title, required this.value, this.onTap});

  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(Dimens.dp24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RegularText(title),
              Dimens.dp4.height,
              HeadingText(
                value,
                style: const TextStyle(
                  fontSize: Dimens.dp24,
                ),
              ),
              Dimens.dp4.height,
              RegularText.semiBold(
                'Lihat Detail',
                style: TextStyle(
                  fontSize: Dimens.dp12,
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
