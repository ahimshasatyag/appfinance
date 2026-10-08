import 'package:flutter/material.dart';
import '../../../../shared/theme/app_theme.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo Image
          Image.asset(
            'assets/images/logofinance.jpg',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          // Title
          const Text(
            'Finance',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppTheme.primaryColor, // Dark text color
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          // Subtitle
          const Text(
            'Personal Finance App',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
