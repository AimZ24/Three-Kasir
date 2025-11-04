import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kasirsuper/features/transaction/models/transaction_model.dart';

class TransactionLocalStorage {
  static const _key = 'transactions';

  static Future<List<TransactionModel>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    final List<dynamic> decoded = jsonDecode(jsonStr);
    return decoded.map((e) => TransactionModel.fromJson(e)).toList();
  }

  static Future<void> saveTransactions(List<TransactionModel> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(transactions.map((t) => t.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}
