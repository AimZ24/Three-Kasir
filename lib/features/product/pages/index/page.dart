import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:kasirsuper/features/product/blocs/product/product_bloc.dart';
import 'package:kasirsuper/features/product/models/product_model.dart';
import 'package:kasirsuper/features/product/pages/form/page.dart';

part 'sections/item_section.dart';

class ProductPage extends StatefulWidget {
  static const routeName = '/products';

  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEditProductPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(Dimens.defaultSize),
                child: SearchTextInput(
                  hintText: 'Cari nama produk',
                  onChanged: (query) {
                    // TODO: Implement search
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Dimens.defaultSize),
                child: SubtitleText('${state.products.length} Produk'),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(Dimens.defaultSize),
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return _ItemSection(product: product);
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: state.products.length,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
