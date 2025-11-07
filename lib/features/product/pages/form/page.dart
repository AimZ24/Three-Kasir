import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:kasirsuper/features/product/blocs/product/product_bloc.dart';
import 'package:kasirsuper/features/product/models/product_model.dart';

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

  String? _imagePath;

  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name);
    _priceController = TextEditingController(
        text: widget.product?.price.toString() ?? '0');
    _descriptionController = TextEditingController(
        text: widget.product?.description);
    // If editing, preload existing image path so preview is shown
    _imagePath = widget.product?.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
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
    if (_imagePath != null && !(_imagePath!.startsWith('http'))) {
      try {
        final id = widget.product?.id ?? DateTime.now().toString();
        final src = File(_imagePath!);
        if (await src.exists()) {
          final d = await getApplicationDocumentsDirectory();
          final imagesDir = Directory('${d.path}/product_images');
          if (!await imagesDir.exists()) await imagesDir.create(recursive: true);
          final ext = _imagePath!.split('.').last;
          final dest = File('${imagesDir.path}/$id.$ext');
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
      id: widget.product?.id ?? DateTime.now().toString(),
      name: _nameController.text,
      price: double.parse(_priceController.text),
      imageUrl: imageUrl,
      description: _descriptionController.text,
    );

    if (isEditing) {
      context.read<ProductBloc>().add(UpdateProduct(product));
    } else {
      context.read<ProductBloc>().add(AddProduct(product));
    }

    if (mounted) Navigator.pop(context);
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
          padding: const EdgeInsets.all(Dimens.dp16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Produk',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama produk harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Harga',
                border: OutlineInputBorder(),
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harga harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            if (_imagePath != null)
              Image.file(
                File(_imagePath!),
                height: 150,
                fit: BoxFit.cover,
              ),
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Unggah Gambar (Opsional)'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(isEditing ? 'Update' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}