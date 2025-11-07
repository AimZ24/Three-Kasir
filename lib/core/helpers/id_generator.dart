import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdGenerator {
  static const String _transactionCounterKey = 'transaction_counter';
  static const String _productCounterKey = 'product_counter';

  /// Generate short transaction ID: TRX-YYYYMMDD-XXXX
  /// Example: TRX-20251107-0001
  static Future<String> generateTransactionId() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyyMMdd').format(DateTime.now());
    final counterKey = '${_transactionCounterKey}_$today';
    
    // Get and increment counter for today
    int counter = (prefs.getInt(counterKey) ?? 0) + 1;
    await prefs.setInt(counterKey, counter);
    
    // Format: TRX-YYYYMMDD-XXXX (with leading zeros)
    final counterStr = counter.toString().padLeft(4, '0');
    return '$today-$counterStr';
  }

  /// Generate short product ID: PRD-YYYYMMDD-XXXX
  /// Example: PRD-20251107-0001
  static Future<String> generateProductId() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyyMMdd').format(DateTime.now());
    final counterKey = '${_productCounterKey}_$today';
    
    // Get and increment counter for today
    int counter = (prefs.getInt(counterKey) ?? 0) + 1;
    await prefs.setInt(counterKey, counter);
    
    // Format: PRD-YYYYMMDD-XXXX (with leading zeros)
    final counterStr = counter.toString().padLeft(4, '0');
    return 'PRD-$today-$counterStr';
  }

  /// Clean up old counters (optional, can be called periodically)
  static Future<void> cleanupOldCounters() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final today = DateFormat('yyyyMMdd').format(DateTime.now());
    
    for (final key in keys) {
      if ((key.startsWith(_transactionCounterKey) || 
           key.startsWith(_productCounterKey)) &&
          !key.contains(today)) {
        await prefs.remove(key);
      }
    }
  }
}
