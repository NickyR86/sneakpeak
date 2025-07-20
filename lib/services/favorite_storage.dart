import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/shoe_model.dart';

class FavoriteStorage {
  static Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/favorites.json';
    print('❤️ Favorites file path: $path');
    return path;
  }

  static Future<Map<String, List<ShoeModel>>> _loadAllFavorites() async {
    final file = File(await _getFilePath());
    if (!file.existsSync()) return {};

    try {
      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;

      return data.map((email, list) {
        final shoeList = (list as List)
            .map((e) => ShoeModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return MapEntry(email, shoeList);
      });
    } catch (e) {
      print('⚠️ Error loading favorites: $e');
      return {};
    }
  }

  static Future<void> saveFavoritesForUser(String email, List<ShoeModel> favorites) async {
    final allData = await _loadAllFavorites();
    allData[email] = favorites;

    final file = File(await _getFilePath());
    final encodedData = allData.map((key, value) =>
        MapEntry(key, value.map((e) => e.toJson()).toList()));

    await file.writeAsString(jsonEncode(encodedData));
    print('✅ Favorites saved for $email with ${favorites.length} items');
  }

  static Future<List<ShoeModel>> loadFavoritesForUser(String email) async {
    final allData = await _loadAllFavorites();
    final favs = allData[email] ?? [];
    print('📥 Loaded ${favs.length} favorites for $email');
    return favs;
  }
}

