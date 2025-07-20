import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/user_storage.dart';
import '../utils/app_textstyles.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key, required this.user});

  final UserModel user;

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.user.address);
  }

  void _showCenterDialog(String title, String message) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "AddressError",
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

  void _saveAddress() async {
    final newAddress = _addressController.text.trim();
    final primaryColor = Theme.of(context).colorScheme.primary;

    if (newAddress.isNotEmpty) {
      await UserStorage.updateUserProfile(
        email: widget.user.email,
        newAddress: newAddress,
      );
      Get.back(result: true);

      Get.snackbar(
        "Address Updated",
        "Your address was successfully updated.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: primaryColor,
        colorText: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    } else {
      _showCenterDialog("Error", "Address cannot be empty.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text("CHANGE ADDRESS", style: AppTextStyle.h3),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Your Address',
                labelStyle: TextStyle(color: Colors.grey.shade800),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAddress,
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

