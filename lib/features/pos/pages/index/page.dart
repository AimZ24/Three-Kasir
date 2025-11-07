import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:kasirsuper/features/pos/blocs/cart/cart_bloc.dart';
import 'package:kasirsuper/features/product/blocs/product/product_bloc.dart';
import 'package:kasirsuper/features/transaction/blocs/transaction/transaction_bloc.dart';
import 'package:kasirsuper/features/transaction/models/transaction_model.dart';
import 'package:kasirsuper/features/pos/pages/barcode_scanner/page.dart';

part 'sections/cart_section.dart';
part 'sections/product_section.dart';

class POSPage extends StatefulWidget {
  const POSPage({super.key});

  @override
  State<POSPage> createState() => _POSPageState();
}

class _POSPageState extends State<POSPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Point of Sale'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan Barcode',
            onPressed: () async {
              final barcode = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (context) => const BarcodeScannerPage(),
                ),
              );
              
              if (barcode != null && mounted) {
                // Find product by barcode
                final productState = context.read<ProductBloc>().state;
                try {
                  final product = productState.products.firstWhere(
                    (p) => p.barcode == barcode,
                  );
                  
                  // Add to cart
                  context.read<CartBloc>().add(AddToCart(product));
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} ditambahkan ke keranjang'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Produk tidak ditemukan'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              context.read<CartBloc>().add(ClearCart());
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // If narrow screen (mobile portrait), stack vertically; otherwise use two-column layout
          final isNarrow = constraints.maxWidth < 700;
          if (isNarrow) {
            return Column(
              children: const [
                // Product list on top
                Expanded(flex: 3, child: _ProductSection()),
                // Cart at bottom
                SizedBox(height: 1),
                Expanded(flex: 2, child: _CartSection()),
              ],
            );
          }

          return Row(
            children: const [
              // Product List Section (2/3 width)
              Expanded(
                flex: 2,
                child: _ProductSection(),
              ),
              // Cart Section (1/3 width)
              Expanded(
                child: _CartSection(),
              ),
            ],
          );
        },
      ),
    );
  }
}
