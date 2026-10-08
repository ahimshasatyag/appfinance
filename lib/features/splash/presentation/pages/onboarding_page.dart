import 'package:flutter/material.dart';
import '../../../../features/auth/presentation/pages/login_page.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../widgets/onboarding_content.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'image': 'assets/images/splash1.jpg',
      'title': 'Track Your Finances',
      'description': 'Keep track of all your income and expenses in one place',
    },
    {
      'image': 'assets/images/splash2.jpg',
      'title': 'Analyze Your Spending',
      'description': 'Understand where your money goes with detailed charts and statistics',
    },
    {
      'image': 'assets/images/splash3.jpg',
      'title': 'Achieve Your Goals',
      'description': 'Set financial goals and watch your savings grow',
    },
  ];

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingContent(
                    image: _onboardingData[index]['image']!,
                    title: _onboardingData[index]['title']!,
                    description: _onboardingData[index]['description']!,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: _currentPage == _onboardingData.length - 1
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Dots Indicator centered
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _onboardingData.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              height: 6,
                              width: _currentPage == index ? 20 : 6,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? AppTheme.primaryColor
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Full width Start button
                        CustomButton(
                          text: 'Start',
                          onPressed: _navigateToLogin,
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Skip Button
                        TextButton(
                          onPressed: _navigateToLogin,
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        // Dots Indicator
                        Row(
                          children: List.generate(
                            _onboardingData.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              height: 6,
                              width: _currentPage == index ? 20 : 6,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? AppTheme.primaryColor
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),

                        // Next Button
                        CustomButton(
                          text: 'Next',
                          width: 120, // using fixed width since it's in a Row with spaceBetween
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          },
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
