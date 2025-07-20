import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ✅ Import controller
import 'controllers/theme_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/favorite_controller.dart';

// ✅ Import utils
import 'utils/app_themes.dart';

// ✅ Import halaman (view)
import 'view/splash_screen.dart';
import 'view/onboarding_screen.dart';
import 'view/login_screen.dart';
import 'view/home_screen.dart';
import 'view/cart_page.dart';
import 'view/checkout_page.dart';
import 'view/payment_page.dart';
import 'view/success_page.dart';
import 'view/favorite_page.dart';
import 'view/product_detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // ✅ Inisialisasi local storage

  final box = GetStorage();

  // ✅ HANYA untuk testing: reset agar onboarding muncul lagi
  // Hapus baris ini setelah selesai testing
  box.remove('seenOnboarding');

  // ✅ Inisialisasi controller global
  Get.put(ThemeController());
  Get.put(CartController());
  Get.put(FavoriteController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      title: 'SneakPeak',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: themeController.theme,
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 400),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/onboarding', page: () => const OnboardingScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/cart', page: () => const CartPage()),
        GetPage(name: '/checkout', page: () => const CheckoutPage()),
        GetPage(name: '/payment', page: () => const PaymentPage()),
        GetPage(name: '/success', page: () => const SuccessPage()),
        GetPage(name: '/favorite', page: () => const FavoritePage()),
        GetPage(
          name: '/detail',
          page: () => ProductDetailPage(shoe: Get.arguments),
        ),
      ],
    );
  }
}
