import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/theme_cubit.dart';
import '../../../../shared/theme/app_theme.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : const Color(0xFF1E293B)),
        centerTitle: true,
        title: Text(
          'Theme Settings', 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
            fontSize: 18,
          ),
        ),
      ),
      body: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, currentThemeMode) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isDarkMode ? [] : [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildThemeOption(
                          context,
                          title: 'Light Mode',
                          subtitle: 'Bright and clean look',
                          icon: Icons.light_mode_outlined,
                          themeMode: ThemeMode.light,
                          currentThemeMode: currentThemeMode,
                          isDarkMode: isDarkMode,
                        ),
                        Divider(height: 1, color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100, indent: 56, endIndent: 16),
                        _buildThemeOption(
                          context,
                          title: 'Dark Mode',
                          subtitle: 'Easy on the eyes',
                          icon: Icons.dark_mode_outlined,
                          themeMode: ThemeMode.dark,
                          currentThemeMode: currentThemeMode,
                          isDarkMode: isDarkMode,
                        ),
                        Divider(height: 1, color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100, indent: 56, endIndent: 16),
                        _buildThemeOption(
                          context,
                          title: 'System Default',
                          subtitle: 'Follows your phone settings',
                          icon: Icons.settings_system_daydream_outlined,
                          themeMode: ThemeMode.system,
                          currentThemeMode: currentThemeMode,
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeMode themeMode,
    required ThemeMode currentThemeMode,
    required bool isDarkMode,
  }) {
    final isSelected = themeMode == currentThemeMode;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1E293B);
    final subtitleColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500;

    return InkWell(
      onTap: () {
        context.read<ThemeCubit>().updateTheme(themeMode);
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppTheme.primaryColor.withOpacity(0.1) 
                    : (isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade50),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon, 
                color: isSelected ? AppTheme.primaryColor : (isDarkMode ? Colors.white70 : Colors.grey.shade600),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, 
                    style: TextStyle(
                      color: textColor, 
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ),
          ],
        ),
      ),
    );
  }
}
