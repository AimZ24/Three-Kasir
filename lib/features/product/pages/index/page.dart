import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  ProductStatus? _statusFilter;
  bool _showLowStockOnly = false;
  
  static const int _itemsPerPage = 20;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProducts());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      _loadMore();
    }
  }

  void _loadMore() {
    setState(() {
      _currentPage++;
    });
  }

  List<ProductModel> _filterProducts(List<ProductModel> products) {
    var filtered = products.where((product) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        if (!product.name.toLowerCase().contains(searchLower) &&
            !(product.barcode?.toLowerCase().contains(searchLower) ?? false)) {
          return false;
        }
      }

      // Status filter
      if (_statusFilter != null && product.status != _statusFilter) {
        return false;
      }

      // Low stock filter
      if (_showLowStockOnly && !product.isLowStock) {
        return false;
      }

      return true;
    }).toList();

    // Pagination
    final endIndex = _currentPage * _itemsPerPage;
    if (endIndex >= filtered.length) {
      return filtered;
    }
    return filtered.sublist(0, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEditProductPage(),
                ),
              );
              if (mounted) {
                context.read<ProductBloc>().add(LoadProducts());
              }
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
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Tidak ada produk'),
                ],
              ),
            );
          }

          final filteredProducts = _filterProducts(state.products);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(Dimens.defaultSize),
                child: SearchTextInput(
                  controller: _searchController,
                  hintText: 'Cari nama produk atau barcode',
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                      _currentPage = 1; // Reset to first page
                    });
                  },
                ),
              ),
              if (_statusFilter != null || _showLowStockOnly)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.defaultSize),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      if (_statusFilter != null)
                        Chip(
                          label: Text(_statusFilter == ProductStatus.active ? 'Aktif' : 'Nonaktif'),
                          onDeleted: () {
                            setState(() {
                              _statusFilter = null;
                              _currentPage = 1;
                            });
                          },
                        ),
                      if (_showLowStockOnly)
                        Chip(
                          label: const Text('Stok Menipis'),
                          onDeleted: () {
                            setState(() {
                              _showLowStockOnly = false;
                              _currentPage = 1;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(Dimens.defaultSize),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SubtitleText('${filteredProducts.length} dari ${state.products.length} Produk'),
                    if (filteredProducts.length < state.products.length)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                            _statusFilter = null;
                            _showLowStockOnly = false;
                            _currentPage = 1;
                          });
                        },
                        child: const Text('Reset Filter'),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: filteredProducts.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('Tidak ada produk yang cocok'),
                          ],
                        ),
                      )
                    : ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(Dimens.defaultSize),
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return _ItemSection(product: product);
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: filteredProducts.length,
                      ),
              )
            ],
          );
        },
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Produk'),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Status Produk'),
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<ProductStatus?>(
                  title: const Text('Semua'),
                  value: null,
                  groupValue: _statusFilter,
                  onChanged: (value) {
                    setDialogState(() {
                      _statusFilter = value;
                    });
                  },
                ),
                RadioListTile<ProductStatus?>(
                  title: const Text('Aktif'),
                  value: ProductStatus.active,
                  groupValue: _statusFilter,
                  onChanged: (value) {
                    setDialogState(() {
                      _statusFilter = value;
                    });
                  },
                ),
                RadioListTile<ProductStatus?>(
                  title: const Text('Nonaktif'),
                  value: ProductStatus.inactive,
                  groupValue: _statusFilter,
                  onChanged: (value) {
                    setDialogState(() {
                      _statusFilter = value;
                    });
                  },
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Stok Menipis'),
                  subtitle: const Text('Tampilkan produk dengan stok rendah'),
                  value: _showLowStockOnly,
                  onChanged: (value) {
                    setDialogState(() {
                      _showLowStockOnly = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentPage = 1;
              });
              Navigator.pop(context);
            },
            child: const Text('Terapkan'),
          ),
        ],
      ),
    );
  }
}
