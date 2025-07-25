import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/user_storage.dart';
import '../utils/app_textstyles.dart';

class Profile2Page extends StatefulWidget {
  const Profile2Page({super.key});

  @override
  State<Profile2Page> createState() => _Profile2PageState();
}

class _Profile2PageState extends State<Profile2Page> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  UserModel? _currentUser;

  String _selectedGender = 'man';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await UserStorage.getLoggedInUser();
    if (user != null) {
      setState(() {
        _currentUser = user;
        _nameController.text = user.displayName;
        _nameController.text = user.username;
        _phoneController.text = user.phone ?? '';
        _selectedGender = user.gender;
      });
    }
  }

  void _showCenterDialog(String title, String message) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Error",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Material(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyle.h3.copyWith(color: Colors.black, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Text(message, style: AppTextStyle.bodySmall.copyWith(color: Colors.black87)),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Text("OK", style: AppTextStyle.buttonLarge.copyWith(color: primaryColor)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final primaryColor = Theme.of(context).colorScheme.primary;

    if (name.isEmpty || phone.isEmpty) {
      _showCenterDialog("Error", "Name and phone number cannot be empty.");
      return;
    }

    final imagePath = 'assets/images/$_selectedGender.jpg';

    await UserStorage.updateUserProfile(
      email: _currentUser!.email,
      newDisplayName: name,
      newPhone: phone,
      newImagePath: imagePath,
      newGender: _selectedGender,
    );

    Get.back(result: true);

    Get.snackbar(
      "Profile Updated",
      "Your profile was successfully updated.",
      snackPosition: SnackPosition.TOP,
      backgroundColor: primaryColor,
      colorText: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text("EDIT PROFILE", style: AppTextStyle.h3),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: Colors.white,
      body: _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(color: Colors.grey.shade800),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: Colors.grey.shade800),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    items: const [
                      DropdownMenuItem(value: 'man', child: Text("Man")),
                      DropdownMenuItem(value: 'woman', child: Text("Woman")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      labelStyle: TextStyle(color: Colors.grey.shade800),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

