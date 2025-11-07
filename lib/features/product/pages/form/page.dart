import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:kasirsuper/features/product/blocs/product/product_bloc.dart';
import 'package:kasirsuper/features/product/models/product_model.dart';
import 'package:kasirsuper/features/product/components/product_barcode_dialog.dart';

class AddEditProductPage extends StatefulWidget {
  const AddEditProductPage({super.key, this.product});

  static const String routeName = '/product/form';
  final ProductModel? product;

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _stockController;
  late final TextEditingController _minStockController;

  String? _imagePath;
  bool _trackStock = false;
  ProductStatus _productStatus = ProductStatus.active;

  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name);
    _priceController = TextEditingController(
        text: widget.product?.price.toString() ?? '0');
    _descriptionController = TextEditingController(
        text: widget.product?.description);
    _stockController = TextEditingController(
        text: widget.product?.stock.toString() ?? '0');
    _minStockController = TextEditingController(
        text: widget.product?.minStock?.toString() ?? '5');
    _trackStock = widget.product?.trackStock ?? false;
    _productStatus = widget.product?.status ?? ProductStatus.active;
    // If editing, preload existing image path so preview is shown
    _imagePath = widget.product?.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    String? imageUrl;
    String productId = widget.product?.id ?? await IdGenerator.generateProductId();
    // Barcode is automatically the product ID
    String barcode = productId;
    
    if (_imagePath != null && !(_imagePath!.startsWith('http'))) {
      try {
        final src = File(_imagePath!);
        if (await src.exists()) {
          final d = await getApplicationDocumentsDirectory();
          final imagesDir = Directory('${d.path}/product_images');
          if (!await imagesDir.exists()) await imagesDir.create(recursive: true);
          final ext = _imagePath!.split('.').last;
          final dest = File('${imagesDir.path}/$productId.$ext');
          try {
            await src.copy(dest.path);
            imageUrl = dest.path;
          } catch (_) {
            imageUrl = _imagePath;
          }
        } else {
          imageUrl = widget.product?.imageUrl;
        }
      } catch (_) {
        imageUrl = widget.product?.imageUrl;
      }
    } else {
      imageUrl = widget.product?.imageUrl;
    }

    final product = ProductModel(
      id: productId,
      name: _nameController.text,
      price: double.parse(_priceController.text),
      imageUrl: imageUrl,
      description: _descriptionController.text,
      barcode: barcode, // Auto-generated from product ID
      stock: int.parse(_stockController.text),
      trackStock: _trackStock,
      status: _productStatus,
      minStock: _trackStock && _minStockController.text.isNotEmpty 
          ? int.parse(_minStockController.text) 
          : null,
    );

    if (isEditing) {
      context.read<ProductBloc>().add(UpdateProduct(product));
      if (mounted) Navigator.pop(context);
    } else {
      context.read<ProductBloc>().add(AddProduct(product));
      if (mounted) {
        Navigator.pop(context);
        // Show barcode dialog after product is created
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => ProductBarcodeDialog(product: product),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Produk' : 'Tambah Produk'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Dimens.dp20),
          children: [
            // Page Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEditing ? 'Edit Produk' : 'Tambah Produk Baru',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: context.theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isEditing 
                      ? 'Perbarui informasi produk yang sudah ada'
                      : 'Lengkapi formulir untuk menambahkan produk',
                    style: TextStyle(
                      fontSize: 14,
                      color: context.theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Image Section with improved design
            _buildSectionCard(
              context: context,
              title: 'Foto Produk',
              icon: Icons.photo_camera,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: _imagePath != null 
                          ? Colors.transparent 
                          : context.theme.primaryColor.withAlpha((0.05 * 255).round()),
                        borderRadius: BorderRadius.circular(Dimens.dp12),
                        border: Border.all(
                          color: context.theme.primaryColor.withAlpha((0.2 * 255).round()),
                          width: 2,
                        ),
                      ),
                      child: _imagePath != null
                        ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(Dimens.dp10),
                                child: Image.file(
                                  File(_imagePath!),
                                  height: 220,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: context.theme.shadowColor.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit, 
                                      color: context.theme.brightness == Brightness.dark 
                                        ? Colors.white 
                                        : Colors.white, 
                                      size: 20
                                    ),
                                    onPressed: _pickImage,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: context.theme.primaryColor.withAlpha((0.1 * 255).round()),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 48,
                                  color: context.theme.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Ketuk untuk menambah foto',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: context.theme.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Format: JPG, PNG (Maks. 5MB)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Product Details Card with improved layout
            _buildSectionCard(
              context: context,
              title: 'Informasi Produk',
              icon: Icons.info_outline,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Nama Produk',
                    hint: 'Contoh: Laptop ASUS ROG',
                    icon: Icons.shopping_bag_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama produk wajib diisi';
                      }
                      if (value.length < 3) {
                        return 'Nama produk minimal 3 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  _buildTextField(
                    controller: _priceController,
                    label: 'Harga Jual',
                    hint: '0',
                    icon: Icons.payments_outlined,
                    prefix: 'Rp ',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harga wajib diisi';
                      }
                      final price = int.tryParse(value);
                      if (price == null || price <= 0) {
                        return 'Harga harus lebih dari 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Deskripsi (Opsional)',
                    hint: 'Tambahkan deskripsi produk...',
                    icon: Icons.notes,
                    maxLines: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Stock Management Card with improved design
            _buildSectionCard(
              context: context,
              title: 'Manajemen Stok & Status',
              icon: Icons.inventory_2_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor.withAlpha((0.05 * 255).round()),
                      borderRadius: BorderRadius.circular(Dimens.dp8),
                      border: Border.all(
                        color: context.theme.primaryColor.withAlpha((0.1 * 255).round()),
                      ),
                    ),
                    child: SwitchListTile(
                      title: const Text(
                        'Lacak Stok Produk',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text(
                        'Aktifkan untuk memantau jumlah stok',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: _trackStock,
                      onChanged: (value) {
                        setState(() {
                          _trackStock = value;
                        });
                      },
                      activeColor: context.theme.primaryColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    ),
                  ),
                  if (_trackStock) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.theme.primaryColor.withAlpha((0.08 * 255).round()),
                        borderRadius: BorderRadius.circular(Dimens.dp8),
                        border: Border.all(
                          color: context.theme.primaryColor.withAlpha((0.2 * 255).round()),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline, 
                                color: context.theme.primaryColor, 
                                size: 20
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Atur jumlah stok dan batas minimum untuk notifikasi',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: context.theme.textTheme.bodyMedium?.color,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: _buildTextField(
                                  controller: _stockController,
                                  label: 'Jumlah Stok',
                                  hint: '0',
                                  icon: Icons.inventory,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  validator: (value) {
                                    if (_trackStock && (value == null || value.isEmpty)) {
                                      return 'Wajib diisi';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: _buildTextField(
                                  controller: _minStockController,
                                  label: 'Min. Stok',
                                  hint: '5',
                                  icon: Icons.warning_amber_outlined,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  const Divider(height: 1),
                  const SizedBox(height: 20),
                  Text(
                    'Status Produk',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<ProductStatus>(
                    value: _productStatus,
                    decoration: InputDecoration(
                      labelText: 'Pilih Status',
                      prefixIcon: Icon(
                        _productStatus == ProductStatus.active 
                          ? Icons.check_circle 
                          : Icons.cancel,
                        color: _productStatus == ProductStatus.active 
                          ? Colors.green 
                          : Colors.red,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimens.dp8),
                      ),
                      filled: true,
                      fillColor: context.theme.inputDecorationTheme.fillColor ?? 
                                 context.theme.cardColor,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: ProductStatus.active,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text('Aktif - Produk dapat dijual'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: ProductStatus.inactive,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text('Nonaktif - Produk tidak dijual'),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _productStatus = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Submit Button with improved design
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.dp12),
                boxShadow: [
                  BoxShadow(
                    color: context.theme.primaryColor.withAlpha((0.3 * 255).round()),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimens.dp12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isEditing ? Icons.update : Icons.save,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isEditing ? 'Update Produk' : 'Simpan Produk',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Cancel Button
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.dp12),
                ),
                side: BorderSide(
                  color: context.theme.primaryColor,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cancel_outlined,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Batal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: context.theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 3,
      shadowColor: context.theme.shadowColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.dp16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.dp16),
          color: context.theme.cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor.withAlpha((0.1 * 255).round()),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: context.theme.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.theme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? prefix,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 22),
        prefixText: prefix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.dp10),
          borderSide: BorderSide(
            color: context.theme.dividerColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.dp10),
          borderSide: BorderSide(
            color: context.theme.dividerColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.dp10),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: context.theme.inputDecorationTheme.fillColor ?? 
                   context.theme.cardColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(
          fontSize: 14,
          color: context.theme.textTheme.bodyMedium?.color,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          fontSize: 14,
          color: context.theme.textTheme.bodySmall?.color?.withOpacity(0.5),
        ),
        alignLabelWithHint: maxLines > 1,
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}