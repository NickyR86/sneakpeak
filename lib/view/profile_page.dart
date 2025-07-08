import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar dan info user
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: const AssetImage('assets/images/avatar.png'),
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Tom Riley',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'tomriley149@gmail.com',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 32),

              _buildMenuItem('Language', Icons.language, primaryColor),
              const Divider(),
              _buildMenuItem('Privacy Policy', Icons.privacy_tip, primaryColor),
              const Divider(),
              _buildMenuItem('Terms and Conditions', Icons.description, primaryColor),
              const Divider(),
              _buildMenuItem('FAQs', Icons.help_outline, primaryColor),
              const Divider(),
              _buildMenuItem('Feedback', Icons.feedback, primaryColor),
              const Divider(),
              _buildMenuItem('Rate Our App', Icons.star_border, primaryColor),
              const Divider(),

              const SizedBox(height: 24),

              // Tombol Logout
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.defaultDialog(
                      titlePadding: const EdgeInsets.only(top: 20),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      title: "Logout",
                      titleStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      content: const Text(
                        "Are you sure you want to logout?",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      confirm: TextButton(
                        onPressed: () {
                          Get.offAll(() => const LoginScreen());
                        },
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: primaryColor, // ✅ pakai warna tema
                          ),
                        ),
                      ),
                      cancel: TextButton(
                        onPressed: () => Get.back(),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, // ✅ warna tombol pakai tema
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, Color primaryColor) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Get.snackbar(title, "$title clicked");
      },
    );
  }
}
