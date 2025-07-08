import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_textstyles.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey _descKey = GlobalKey();
  final GlobalKey _resetButtonKey = GlobalKey();

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
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  void _showCustomDialog(String title, String message, Color primaryColor) {
    final RenderBox renderBox = _descKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final double dialogTop = offset.dy + renderBox.size.height + 8;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "InfoDialog",
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
          position: Tween<Offset>(
            begin: const Offset(0, 0.4),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  void _handleReset() {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showCustomDialog("Reset Failed", "Email field cannot be empty.", primaryColor);
      return;
    }

    if (!email.endsWith("@gmail.com")) {
      _showCustomDialog("Invalid Email", "Email must end with @gmail.com", primaryColor);
      return;
    }

    _showCustomDialog("Check Your Email", "We have sent password recovery instructions to your email.", primaryColor);
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 16),
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.keyboard_arrow_left, color: Colors.black, size: 35),
                ),
                const SizedBox(height: 18),
                Text("Reset Password", style: AppTextStyle.h2),
                const SizedBox(height: 8),
                Text(
                  "Enter your email to reset your password.",
                  key: _descKey,
                  style: AppTextStyle.bodySmall.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // Email Field
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Reset Button
                Container(
                  key: _resetButtonKey,
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _handleReset,
                      child: Center(
                        child: Text(
                          'Reset Password',
                          style: AppTextStyle.buttonLarge.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
