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
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  
  int _currentPage = 1;
  final int _itemsPerPage = 20;
  TransactionStatus? _selectedStatus;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(LoadTransactions());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      setState(() {
        _currentPage++;
      });
    }
  }

  List<TransactionModel> _filterTransactions(List<TransactionModel> transactions) {
    var filtered = transactions;

    // Search by transaction ID
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((transaction) {
        return transaction.id.toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();
    }

    // Filter by status
    if (_selectedStatus != null) {
      filtered = filtered.where((transaction) {
        return transaction.status == _selectedStatus;
      }).toList();
    }

    // Filter by date range
    if (_startDate != null) {
      filtered = filtered.where((transaction) {
        return transaction.date.isAfter(_startDate!) || 
               transaction.date.isAtSameMomentAs(_startDate!);
      }).toList();
    }

    if (_endDate != null) {
      filtered = filtered.where((transaction) {
        final endOfDay = DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59);
        return transaction.date.isBefore(endOfDay) || 
               transaction.date.isAtSameMomentAs(endOfDay);
      }).toList();
    }

    // Apply pagination
    final totalItems = filtered.length;
    final maxItems = _currentPage * _itemsPerPage;
    return filtered.take(maxItems > totalItems ? totalItems : maxItems).toList();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Filter Transaksi'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<TransactionStatus?>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Semua')),
                  ...TransactionStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.name.toUpperCase()),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text('Tanggal Mulai:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: dialogContext,
                    initialDate: _startDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _startDate = date;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(_startDate != null 
                  ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                  : 'Pilih Tanggal'),
              ),
              const SizedBox(height: 16),
              const Text('Tanggal Akhir:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: dialogContext,
                    initialDate: _endDate ?? DateTime.now(),
                    firstDate: _startDate ?? DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _endDate = date;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(_endDate != null 
                  ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                  : 'Pilih Tanggal'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedStatus = null;
                _startDate = null;
                _endDate = null;
                _currentPage = 1;
              });
              Navigator.pop(dialogContext);
            },
            child: const Text('Reset'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentPage = 1;
              });
              Navigator.pop(dialogContext);
            },
            child: const Text('Terapkan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimens.defaultSize),
            child: Column(
              children: [
                SearchTextInput(
                  controller: _searchController,
                  hintText: 'Cari ID transaksi...',
                  onChanged: (value) {
                    setState(() {
                      _currentPage = 1;
                    });
                  },
                ),
                if (_selectedStatus != null || _startDate != null || _endDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Wrap(
                      spacing: 8,
                      children: [
                        if (_selectedStatus != null)
                          Chip(
                            label: Text('Status: ${_selectedStatus!.name.toUpperCase()}'),
                            onDeleted: () {
                              setState(() {
                                _selectedStatus = null;
                                _currentPage = 1;
                              });
                            },
                          ),
                        if (_startDate != null)
                          Chip(
                            label: Text('Dari: ${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'),
                            onDeleted: () {
                              setState(() {
                                _startDate = null;
                                _currentPage = 1;
                              });
                            },
                          ),
                        if (_endDate != null)
                          Chip(
                            label: Text('Sampai: ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'),
                            onDeleted: () {
                              setState(() {
                                _endDate = null;
                                _currentPage = 1;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state.status == Status.loading && state.transactions.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == Status.failure) {
                  return Center(child: Text(state.error ?? 'Error occurred'));
                }

                if (state.transactions.isEmpty) {
                  return const Center(child: Text('Tidak ada transaksi'));
                }

                final filteredTransactions = _filterTransactions(state.transactions);

                if (filteredTransactions.isEmpty) {
                  return const Center(child: Text('Tidak ada transaksi yang sesuai dengan filter'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.defaultSize),
                  itemCount: filteredTransactions.length + 
                      (filteredTransactions.length < state.transactions.length ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= filteredTransactions.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    
                    final transaction = filteredTransactions[index];
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
