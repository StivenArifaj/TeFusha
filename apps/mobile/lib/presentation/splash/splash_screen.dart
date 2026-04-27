import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../data/datasources/local/token_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  Future<void> _startTimer() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    _checkNavigation();
  }

  Future<void> _checkNavigation() async {
    final isLoggedIn = await TokenStorage.isLoggedIn();
    
    if (isLoggedIn) {
      if (mounted) context.go('/home');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool('onboarding_done') ?? false;

    if (!mounted) return;
    if (!onboardingDone) {
      context.go('/onboarding');
    } else {
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/logo_animation.json',
              width: 200,
              repeat: false,
              errorBuilder: (context, error, stackTrace) {
                // Fallback if animation is missing
                return Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.sports_soccer, color: Colors.white, size: 80),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'TeFusha',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Rezervo fushën tënde sportive',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
