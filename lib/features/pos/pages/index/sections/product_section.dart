part of '../page.dart';

class _ProductSection extends StatelessWidget {
  const _ProductSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == Status.failure) {
          return Center(child: Text(state.error ?? 'Error occurred'));
        }

        if (state.products.isEmpty) {
          return const Center(child: Text('Tidak ada produk'));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimens.defaultSize),
              child: SearchTextInput(
                hintText: 'Cari produk...',
                onChanged: (query) {
                  // TODO: Implement search
                },
              ),
            ),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                // adapt number of columns to available width
                int crossAxisCount;
                final w = constraints.maxWidth;
                if (w > 1000) {
                  crossAxisCount = 4;
                } else if (w > 700) {
                  crossAxisCount = 3;
                } else if (w > 400) {
                  crossAxisCount = 2;
                } else {
                  crossAxisCount = 1;
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(Dimens.defaultSize),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: Dimens.defaultSize,
                    mainAxisSpacing: Dimens.defaultSize,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return Card(
                      child: InkWell(
                        onTap: () {
                          context.read<CartBloc>().add(AddToCart(product));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(Dimens.dp8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Center(
                                  child: product.imageUrl != null
                                      ? Image.network(
                                          product.imageUrl!,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          color: context.theme.cardColor,
                                          child: Icon(
                                            Icons.image,
                                            size: 48,
                                            color: context.theme.iconTheme.color?.withOpacity(0.5),
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: Dimens.dp8),
                              Text(
                                product.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: context.theme.textTheme.bodyLarge?.color,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: Dimens.dp4),
                              Text(
                                'Rp ${product.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              // stock removed for cafe cashier UI
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        );
      },
    );
  }
}