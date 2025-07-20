import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/cart_item.dart';

class CartStorage {
  static Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/cart.json';
    print('🛒 Cart file path: $path');
    return path;
  }

  static Future<Map<String, List<CartItem>>> _loadAllCartData() async {
    final file = File(await _getFilePath());
    if (!file.existsSync()) return {};

    try {
      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;

      return data.map((email, list) => MapEntry(
        email,
        (list as List).map((e) => CartItem.fromJson(e)).toList(),
      ));
    } catch (e) {
      print('⚠️ Error loading cart data: $e');
      return {};
    }
  }

  static Future<void> saveCartForUser(String email, List<CartItem> items) async {
    final allData = await _loadAllCartData();
    allData[email] = items;

    final file = File(await _getFilePath());
    final encodedData = allData.map((key, value) =>
      MapEntry(key, value.map((e) => e.toJson()).toList()));

    await file.writeAsString(jsonEncode(encodedData));
    print('✅ Cart saved for $email with ${items.length} items');
  }

  static Future<List<CartItem>> loadCartForUser(String email) async {
    final allData = await _loadAllCartData();
    final items = allData[email] ?? [];
    print('📥 Loaded ${items.length} cart items for $email');
    return items;
  }
}
