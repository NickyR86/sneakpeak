import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_textstyles.dart';
import '../models/user_model.dart';
import '../services/user_storage.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import '../controllers/cart_controller.dart';
import '../controllers/favorite_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  bool _isPasswordObscured = true;
  bool _rememberMe = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey _descKey = GlobalKey();

  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  String selectedGender = 'man';

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
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

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
      barrierLabel: "SignupErrorDialog",
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

  void _handleSignup() async {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showErrorDialog("Signup Failed", "Please fill in all fields.");
      return;
    }

    if (!email.endsWith("@gmail.com")) {
      _showErrorDialog("Invalid Email", "Email must end with @gmail.com");
      return;
    }

    try {
      final imagePath = 'assets/images/$selectedGender.jpg';

      final newUser = UserModel(
        username: username,
        email: email,
        password: password,
        gender: selectedGender,
        imagePath: imagePath,
      );

      await UserStorage.addUser(newUser);
      await UserStorage.saveLoggedInUser(newUser);

      Get.find<CartController>().setUserEmail(email);
      Get.find<FavoriteController>().setUserEmail(email);

      Get.snackbar(
        "Signup Successful",
        "Welcome! You are now logged in.",
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
    } catch (e) {
      _showErrorDialog("Signup Failed", e.toString());
    }
  }

  Widget _genderBox(String gender, IconData icon) {
    final isSelected = selectedGender == gender;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedGender = gender),
        child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(color: isSelected ? primaryColor : Colors.transparent, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20, color: isSelected ? primaryColor : Colors.grey),
                const SizedBox(width: 8),
                Text(
                  gender == 'man' ? 'Man' : 'Woman',
                  style: TextStyle(
                    color: isSelected ? primaryColor : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _emailController.dispose();
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
                Text("Create Account", style: AppTextStyle.h2),
                const SizedBox(height: 8),
                Text("Please register to login.", key: _descKey, style: AppTextStyle.bodySmall.copyWith(color: Colors.grey)),
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
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _passwordController,
                  obscureText: _isPasswordObscured,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordObscured ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    _genderBox('man', Icons.male),
                    _genderBox('woman', Icons.female),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) => setState(() => _rememberMe = value!),
                      activeColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    Text("Remind me next time", style: AppTextStyle.bodySmall),
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
                      onTap: _handleSignup,
                      child: Center(
                        child: Text('Sign Up', style: AppTextStyle.buttonLarge.copyWith(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => Get.off(() => const LoginScreen(), transition: Transition.fadeIn),
                      child: Text("Login", style: AppTextStyle.buttonSmall.copyWith(color: primaryColor)),
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




