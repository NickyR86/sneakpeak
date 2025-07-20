import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../utils/app_textstyles.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final box = GetStorage();
  int _currentIndex = 0;

  final List<_OnboardingData> onboardingData = [
    _OnboardingData(
      imagePath: 'assets/images/shoe.jpg',
      title: 'DISCOVER',
      description: 'Explore the latest sneaker trends from top global brands.',
    ),
    _OnboardingData(
      imagePath: 'assets/images/shoe2.png',
      title: 'CUSTOMIZE',
      description: 'Find your perfect fit by filtering size, color, and style.',
    ),
    _OnboardingData(
      imagePath: 'assets/images/shoe3.png',
      title: 'SHOP',
      description: 'Enjoy a fast, secure, and seamless checkout experience.',
    ),
  ];

  void _goToNextPage() {
    if (_currentIndex < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    box.write('seenOnboarding', true);
    Get.off(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final screenHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Gambar fullscreen di bagian atas
            SizedBox(
              height: screenHeight * 0.6,
              width: double.infinity,
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.asset(
                    onboardingData[index].imagePath,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),

            // Konten bawah
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      onboardingData[_currentIndex].title,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.h2.copyWith(
                        color: Theme.of(context).textTheme.headlineMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      onboardingData[_currentIndex].description,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.75),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Dot indikator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingData.length,
                        (dotIndex) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentIndex == dotIndex ? 12 : 8,
                          height: _currentIndex == dotIndex ? 12 : 8,
                          decoration: BoxDecoration(
                            color: _currentIndex == dotIndex
                                ? primaryColor
                                : Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Tombol utama
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _currentIndex == onboardingData.length - 1
                            ? _completeOnboarding
                            : _goToNextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _currentIndex == onboardingData.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: AppTextStyle.buttonLarge.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    if (_currentIndex < onboardingData.length - 1)
                      GestureDetector(
                        onTap: _completeOnboarding,
                        child: Text(
                          'Skip',
                          style: AppTextStyle.bodyMedium.copyWith(color: primaryColor),
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
  }
}

class _OnboardingData {
  final String imagePath;
  final String title;
  final String description;

  _OnboardingData({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}
