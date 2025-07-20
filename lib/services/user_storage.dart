import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/user_model.dart';

class UserStorage {
  static const List<String> defaultAvatars = [
    'assets/images/man.jpg',
    'assets/images/woman.jpg',
  ];

  static Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/users.json';
  }

  /// Tambah user baru
  static Future<void> addUser(UserModel newUser) async {
    final filePath = await _getFilePath();
    final file = File(filePath);

    List<UserModel> users = [];

    if (await file.exists()) {
      final content = await file.readAsString();
      if (content.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(content);
        users = jsonList.map((e) => UserModel.fromJson(e)).toList();
      }
    }

    if (users.any((u) => u.email == newUser.email)) {
      throw Exception('Email already registered');
    }

    // Atur imagePath berdasarkan gender
    String selectedAvatar = newUser.imagePath;
    if (selectedAvatar.isEmpty) {
      selectedAvatar = newUser.gender == 'woman'
          ? 'assets/images/woman.jpg'
          : 'assets/images/man.jpg';
    }

    final userWithDefaults = UserModel(
      username: newUser.username,
      email: newUser.email,
      password: newUser.password,
      gender: newUser.gender,
      imagePath: selectedAvatar,
      address: 'Address not set',
      phone: 'Phone number not set',
    );

    users.add(userWithDefaults);
    final jsonData = jsonEncode(users.map((u) => u.toJson()).toList());
    await file.writeAsString(jsonData);
  }

  /// Simpan user yang sedang login
  static Future<void> saveLoggedInUser(UserModel user) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/logged_user.json');
    final json = jsonEncode(user.toJson());
    await file.writeAsString(json);
  }

  /// Ambil data user yang sedang login
  static Future<UserModel?> getLoggedInUser() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/logged_user.json');
    if (await file.exists()) {
      final content = await file.readAsString();
      final json = jsonDecode(content);
      return UserModel.fromJson(json);
    }
    return null;
  }

  /// Hapus user yang sedang login
  static Future<void> clearLoggedInUser() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/logged_user.json');
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Ambil semua user dari file
  static Future<List<UserModel>> getAllUsers() async {
    final filePath = await _getFilePath();
    final file = File(filePath);

    if (await file.exists()) {
      final content = await file.readAsString();
      if (content.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(content);
        return jsonList.map((e) => UserModel.fromJson(e)).toList();
      }
    }
    return [];
  }

  /// Cari user berdasarkan username
  static Future<UserModel?> getUserByUsername(String username) async {
    final users = await getAllUsers();
    try {
      return users.firstWhere((user) => user.username == username);
    } catch (_) {
      return null;
    }
  }

  /// Update profil user (nama, phone, alamat, gambar, gender)
  static Future<void> updateUserProfile({
    required String email,
    String? newUsername,
    String? newImagePath,
    String? newAddress,
    String? newPhone,
    String? newGender,
  }) async {
    final filePath = await _getFilePath();
    final file = File(filePath);

    if (!await file.exists()) return;

    final content = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(content);
    final users = jsonList.map((e) => UserModel.fromJson(e)).toList();

    final index = users.indexWhere((u) => u.email == email);
    if (index != -1) {
      final oldUser = users[index];

      final updatedUser = UserModel(
        username: newUsername ?? oldUser.username,
        email: oldUser.email,
        password: oldUser.password,
        gender: newGender ?? oldUser.gender,                 // ✅ Update gender
        imagePath: newImagePath ?? oldUser.imagePath,
        address: newAddress ?? oldUser.address,
        phone: newPhone ?? oldUser.phone,
      );

      users[index] = updatedUser;
      final jsonData = jsonEncode(users.map((u) => u.toJson()).toList());
      await file.writeAsString(jsonData);

      /// Simpan juga sebagai user yang sedang login
      await saveLoggedInUser(updatedUser);
    }
  }
}

