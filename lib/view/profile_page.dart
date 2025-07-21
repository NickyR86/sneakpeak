import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/user_storage.dart';
import '../models/user_model.dart';
import 'address_page.dart';
import 'login_screen.dart';
import 'profile2_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserModel?> _futureUser;
  final double borderWidth = 3.0;

  @override
  void initState() {
    super.initState();
    _futureUser = UserStorage.getLoggedInUser();
  }

  void _editProfile(UserModel user) async {
    final result = await Get.to(() => const Profile2Page());
    if (result == true) {
      setState(() {
        _futureUser = UserStorage.getLoggedInUser();
      });
    }
  }

  Future<void> _openAddressPage(UserModel user) async {
    final result = await Get.to(() => AddressPage(user: user));
    if (result == true) {
      setState(() {
        _futureUser = UserStorage.getLoggedInUser();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return FutureBuilder<UserModel?>(
      future: _futureUser,
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Scaffold(
          backgroundColor: primaryColor,
          body: SafeArea(
            child: Column(
              children: [
                // 🔵 Header dengan gradient dan grid
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryColor,
                        primaryColor.withOpacity(0.8),
                        primaryColor.withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: GridBackgroundPainter(),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80 + borderWidth * 2,
                              height: 80 + borderWidth * 2,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(borderWidth),
                              child: ClipOval(
                                child: Image.asset(
                                  user?.imagePath.isNotEmpty == true
                                      ? user!.imagePath
                                      : 'assets/images/man.jpg',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              user?.username ?? '-',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              user?.email ?? '-',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.address ?? 'Address not set',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ⚪ Scrollable content
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      children: [
                        if (user != null) ...[
                          ListTile(
                            leading: Icon(Icons.person, color: primaryColor),
                            title: const Text("Edit Profile"),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _editProfile(user),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Icon(Icons.edit_location_alt, color: primaryColor),
                            title: const Text("Change Address"),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _openAddressPage(user),
                          ),
                          const Divider(),
                        ],
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
                                  onPressed: () async {
                                    await UserStorage.clearLoggedInUser();
                                    Get.offAll(() => const LoginScreen());
                                  },
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: primaryColor,
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
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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


class GridBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..strokeWidth = 1;

    const step = 20.0;

    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
