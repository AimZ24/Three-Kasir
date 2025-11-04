import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kasirsuper/core/core.dart';

class ReceiptSettingsPage extends StatefulWidget {
  const ReceiptSettingsPage({super.key});

  static const String routeName = '/settings/receipt';

  @override
  State<ReceiptSettingsPage> createState() => _ReceiptSettingsPageState();
}

class _ReceiptSettingsPageState extends State<ReceiptSettingsPage> {
  final _headerController = TextEditingController();
  final _footerController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _footerController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _headerController.text = prefs.getString('receipt_header') ?? '';
      _footerController.text = prefs.getString('receipt_footer') ?? '';
      _loading = false;
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('receipt_header', _headerController.text);
    await prefs.setString('receipt_footer', _footerController.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receipt settings saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(Dimens.defaultSize),
              children: [
                RegularText.semiBold('Header'),
                Dimens.dp8.height,
                RegularTextInput(
                  controller: _headerController,
                  label: 'Receipt Header',
                  hintText: 'Store name or address',
                ),
                Dimens.dp16.height,
                RegularText.semiBold('Footer'),
                Dimens.dp8.height,
                RegularTextInput(
                  controller: _footerController,
                  label: 'Receipt Footer',
                  hintText: 'Thank you message',
                  maxLines: 3,
                ),
              ],
            ),
    );
  }
}