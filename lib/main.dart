// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// import 'controllers/theme_controller.dart';
// import 'controllers/cart_controller.dart';
// import 'utils/app_themes.dart';

// import 'view/splash_screen.dart';
// import 'view/cart_page.dart';
// import 'view/checkout_page.dart'; // ✅ import halaman checkout

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await GetStorage.init();

//   // Inisialisasi controller global
//   Get.put(ThemeController());
//   Get.put(CartController());

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeController = Get.find<ThemeController>();

//     return GetMaterialApp(
//       title: 'SneakPeak',
//       theme: AppThemes.light,
//       darkTheme: AppThemes.dark,
//       themeMode: themeController.theme,
//       debugShowCheckedModeBanner: false,
//       defaultTransition: Transition.fade,

//       // Awal aplikasi: SplashScreen
//       initialRoute: '/',
//       getPages: [
//         GetPage(name: '/', page: () => const SplashScreen()),
//         GetPage(name: '/cart', page: () => const CartPage()),
//         GetPage(name: '/checkout', page: () => const CheckoutPage()),
//         // Tambahkan route lain seperti '/home', '/detail', dll jika ada
//       ],
//     );
//   }
// }
// ✅ FINAL main.dart lengkap dengan controller, routing, dan theme setup
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ✅ Import controller
import 'controllers/theme_controller.dart';
import 'controllers/cart_controller.dart';

// ✅ Import utils
import 'utils/app_themes.dart';

// ✅ Import halaman (view)
import 'view/splash_screen.dart';
import 'view/cart_page.dart';
import 'view/checkout_page.dart';
import 'view/payment_page.dart';
import 'view/success_page.dart'; // ✅ Tambahkan ini

// import halaman lain jika ada, contoh:
// import 'view/home_screen.dart';
// import 'view/product_detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Inisialisasi controller global
  Get.put(ThemeController());
  Get.put(CartController());

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

      // ✅ Atur halaman pertama saat app dibuka
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/cart', page: () => const CartPage()),
        GetPage(name: '/checkout', page: () => const CheckoutPage()),
        GetPage(name: '/payment', page: () => const PaymentPage()),
        GetPage(name: '/success', page: () => const SuccessPage()), // ✅ Route untuk halaman success
        // GetPage(name: '/home', page: () => const HomeScreen()),
        // GetPage(name: '/detail', page: () => const ProductDetailPage()),
      ],
    );
  }
}
