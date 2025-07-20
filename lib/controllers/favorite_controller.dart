import 'package:get/get.dart';
import '../models/shoe_model.dart';
import '../services/favorite_storage.dart';

class FavoriteController extends GetxController {
  final RxList<ShoeModel> _favorites = <ShoeModel>[].obs;
  String? _userEmail;

  List<ShoeModel> get favorites => _favorites;

  /// ✅ Set email user saat login/signup (wajib dipanggil sebelum load/toggle)
  void setUserEmail(String email) async {
    _userEmail = email;
    await loadFavorites();
  }

  /// ✅ Toggle status favorit (tambahkan atau hapus dari daftar)
  void toggleFavorite(ShoeModel shoe) {
    final index = _favorites.indexWhere((item) => item.title == shoe.title);
    if (index != -1) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(shoe);
    }
    update();
    _saveFavorites();
  }

  /// ✅ Mengecek apakah item sudah ada di favorit
  bool isFavorite(ShoeModel shoe) {
    return _favorites.any((item) => item.title == shoe.title);
  }

  /// ✅ Hapus sepatu dari favorit
  void removeFavorite(ShoeModel shoe) {
    _favorites.removeWhere((item) => item.title == shoe.title);
    update();
    _saveFavorites();
  }

  /// ✅ Bersihkan semua data favorit user
  void clearFavorites() {
    _favorites.clear();
    update();
    _saveFavorites();
  }

  /// ✅ Muat semua data favorit user dari storage
  Future<void> loadFavorites() async {
    if (_userEmail == null || _userEmail!.isEmpty) return;
    final loaded = await FavoriteStorage.loadFavoritesForUser(_userEmail!);
    _favorites.assignAll(loaded);
    update();
  }

  /// ✅ Simpan favorit user ke storage
  Future<void> _saveFavorites() async {
    if (_userEmail == null || _userEmail!.isEmpty) return;
    await FavoriteStorage.saveFavoritesForUser(_userEmail!, _favorites);
  }
}

