import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:kasirsuper/features/transaction/blocs/transaction/transaction_bloc.dart';
import 'package:kasirsuper/features/transaction/models/transaction_model.dart';
import 'package:kasirsuper/features/transaction/pages/detail/page.dart';

part 'sections/filter_section.dart';
part 'sections/item_section.dart';

class TransactionPage extends StatefulWidget {
  static const routeName = '/transactions';

  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(LoadTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _FilterSection(),
          Expanded(
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state.status == Status.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == Status.failure) {
                  return Center(child: Text(state.error ?? 'Error occurred'));
                }

                if (state.transactions.isEmpty) {
                  return const Center(child: Text('Tidak ada transaksi'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(Dimens.defaultSize),
                  itemCount: state.transactions.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final transaction = state.transactions[index];
                    return _ItemSection(transaction: transaction);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
