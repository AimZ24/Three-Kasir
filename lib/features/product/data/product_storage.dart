import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kasirsuper/features/product/models/product_model.dart';

class ProductLocalStorage {
  static const String _key = 'products';

  static Future<List<ProductModel>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? productsJson = prefs.getString(_key);
    if (productsJson == null) return [];

    final List<dynamic> decoded = jsonDecode(productsJson);
    return decoded.map((json) => ProductModel.fromJson(json)).toList();
  }

  static Future<void> saveProducts(List<ProductModel> products) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(products.map((p) => p.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}