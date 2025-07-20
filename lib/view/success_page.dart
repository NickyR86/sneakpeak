import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_textstyles.dart';
import '../controllers/cart_controller.dart';
import '../services/cart_storage.dart';
import '../services/user_storage.dart';
import 'home_screen.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: Image.asset(
                'assets/images/shopbag.png',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "SUCCESS !",
              style: AppTextStyle.h2.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Text(
                    "Your Order Will Be Delivered Soon.",
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Thank You For Choosing Our App !",
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),

      // ✅ Tombol di bagian bawah layar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ElevatedButton(
          onPressed: () async {
            cartController.clearCart();

            final user = await UserStorage.getLoggedInUser();
            if (user != null) {
              await CartStorage.saveCartForUser(user.email, []); // ✅ Hapus cart file user
            }

            Get.offAll(() => const HomeScreen());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "CONTINUE SHOPPING",
            style: AppTextStyle.buttonMedium.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}



