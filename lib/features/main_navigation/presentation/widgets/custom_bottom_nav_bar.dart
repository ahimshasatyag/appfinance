import 'package:flutter/material.dart';
import '../../../../shared/theme/app_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.white,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: currentIndex == 0 ? AppTheme.primaryColor : Colors.grey),
              onPressed: () => onTap(0),
            ),
            IconButton(
              icon: Icon(Icons.bar_chart, color: currentIndex == 1 ? AppTheme.primaryColor : Colors.grey),
              onPressed: () => onTap(1),
            ),
            const SizedBox(width: 48), // Space for FAB
            IconButton(
              icon: Icon(Icons.account_balance_wallet_outlined, color: currentIndex == 2 ? AppTheme.primaryColor : Colors.grey),
              onPressed: () => onTap(2),
            ),
            IconButton(
              icon: Icon(Icons.person_outline, color: currentIndex == 3 ? AppTheme.primaryColor : Colors.grey),
              onPressed: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}
