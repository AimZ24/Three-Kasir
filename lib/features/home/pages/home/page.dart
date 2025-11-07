import 'package:flutter/material.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:kasirsuper/features/transaction/pages/index/page.dart';
import 'package:kasirsuper/features/product/pages/index/page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasirsuper/features/transaction/blocs/transaction/transaction_bloc.dart';
import 'package:kasirsuper/features/product/blocs/product/product_bloc.dart';

part 'sections/card_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(LoadTransactions());
    context.read<ProductBloc>().add(LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimens.defaultSize),
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, txState) {
            return BlocBuilder<ProductBloc, ProductState>(
              builder: (context, pState) {
                final totalTransactions = txState.transactions.length;
                final totalSales = txState.transactions.fold<double>(
                    0, (prev, t) => prev + (t.total));
                final totalProducts = pState.products.length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CardSection(
                      title: 'Total Penjualan',
                      value: 'Rp ${totalSales.toStringAsFixed(0)}',
                      onTap: () {
                        Navigator.pushNamed(context, TransactionPage.routeName);
                      },
                    ),
                    Dimens.defaultSize.height,
                    _CardSection(
                      title: 'Total Transaksi',
                      value: totalTransactions.toString(),
                      onTap: () {
                        Navigator.pushNamed(context, TransactionPage.routeName);
                      },
                    ),
                    Dimens.defaultSize.height,
                    _CardSection(
                      title: 'Total Produk',
                      value: totalProducts.toString(),
                      onTap: () {
                        Navigator.pushNamed(context, ProductPage.routeName);
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
