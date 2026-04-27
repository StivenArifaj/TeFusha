import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool _isLastPage = false;

  final List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      title: 'Gjej Fushën Perfekte',
      body: 'Kërko qindra fusha sportive sipas qytetit, llojit dhe çmimit tuaj.',
      icon: Icons.search,
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.primaryLight, Colors.white],
      ),
      iconColor: AppColors.primary,
    ),
    _OnboardingPageData(
      title: 'Rezervo me Një Klik',
      body: 'Zgjidh datën dhe orarin dhe konfirmo rezervimin tënd brenda sekondave.',
      icon: Icons.calendar_today,
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE8F5E9), Colors.white],
      ),
      iconColor: AppColors.sportFootball,
    ),
    _OnboardingPageData(
      title: 'Lëro & Garoje',
      body: 'Gjej lojtar, formo ekipin tënd dhe regjistrohu në kampionate lokale.',
      icon: Icons.emoji_events,
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE3F2FD), Colors.white],
      ),
      iconColor: AppColors.sportVolleyball,
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (mounted) {
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() => _isLastPage = index == _pages.length - 1);
            },
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Column(
                children: [
                  // Top 55%
                  Expanded(
                    flex: 55,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(gradient: page.gradient),
                      child: Center(
                        child: Icon(
                          page.icon,
                          size: 120,
                          color: page.iconColor,
                        ),
                      ),
                    ),
                  ),
                  // Bottom 45%
                  Expanded(
                    flex: 45,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            page.title,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            page.body,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textMedium,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Navigation elements
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: _pages.length,
                  effect: const ScrollingDotsEffect(
                    activeDotColor: AppColors.primary,
                    dotColor: AppColors.divider,
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotScale: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_isLastPage) {
                        _completeOnboarding();
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(_isLastPage ? 'Fillo' : 'Vazhdo'),
                  ),
                ),
                const SizedBox(height: 12),
                if (!_isLastPage)
                  TextButton(
                    onPressed: _completeOnboarding,
                    child: const Text(
                      'Kalo',
                      style: TextStyle(color: AppColors.textMedium),
                    ),
                  )
                else
                  const SizedBox(height: 48), // Placeholder for TextButton height
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageData {
  final String title;
  final String body;
  final IconData icon;
  final Gradient gradient;
  final Color iconColor;

  _OnboardingPageData({
    required this.title,
    required this.body,
    required this.icon,
    required this.gradient,
    required this.iconColor,
  });
}
