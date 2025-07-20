import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_textstyles.dart';
import '../services/user_storage.dart';
import '../models/user_model.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import '../controllers/cart_controller.dart';
import '../controllers/favorite_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  final GlobalKey _descKey = GlobalKey();
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  void _showErrorDialog(String title, String message) {
    final RenderBox renderBox = _descKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final double dialogTop = offset.dy + renderBox.size.height + 4;
    final primaryColor = Theme.of(context).colorScheme.primary;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "LoginErrorDialog",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            Positioned(
              top: dialogTop,
              left: 32,
              right: 32,
              child: Material(
                color: Colors.transparent,
                child: Container(
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
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: Text("OK", style: AppTextStyle.buttonLarge.copyWith(color: primaryColor)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, anim1, _, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final primaryColor = Theme.of(context).colorScheme.primary;

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog("Login Failed", "Please enter both username and password.");
      return;
    }

    final user = await UserStorage.getUserByUsername(username);

    if (user != null && user.password == password) {
      await UserStorage.saveLoggedInUser(user);

      // Set user email ke controller cart & favorite
      Get.find<CartController>().setUserEmail(user.email);
      Get.find<FavoriteController>().setUserEmail(user.email);

      Get.snackbar(
        "Login Successful",
        "Welcome back, ${user.username}!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: primaryColor,
        colorText: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );

      Future.delayed(const Duration(milliseconds: 1500), () {
        Get.offAll(() => const HomeScreen(), transition: Transition.fadeIn, duration: const Duration(milliseconds: 400));
      });
    } else {
      _showErrorDialog("Login Failed", "Invalid username or password.");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 75),
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo2.png', height: 30),
                    const SizedBox(width: 12),
                    Text('SNEAKPEAK', style: AppTextStyle.h2.copyWith(color: primaryColor, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 50),
                Text("Welcome Back!", style: AppTextStyle.h2),
                const SizedBox(height: 8),
                Text("Login to your account.", key: _descKey, style: AppTextStyle.bodySmall.copyWith(color: Colors.grey)),
                const SizedBox(height: 24),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) => setState(() => _rememberMe = value!),
                          activeColor: primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        Text("Remember me", style: AppTextStyle.bodySmall),
                      ],
                    ),
                    TextButton(
                      onPressed: () => Get.to(() => const ForgotPasswordScreen(), transition: Transition.fadeIn),
                      child: Text("Forgot Password?", style: AppTextStyle.bodySmall.copyWith(color: primaryColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(12)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _handleLogin,
                      child: Center(
                        child: Text('Login', style: AppTextStyle.buttonLarge.copyWith(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () => Get.to(() => const SignupScreen(), transition: Transition.fadeIn),
                      child: Text("Sign Up", style: AppTextStyle.buttonSmall.copyWith(color: primaryColor)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

