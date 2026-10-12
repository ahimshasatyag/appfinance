import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/config/l10n.dart';
import '../widgets/language_option_item.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
        ),
        centerTitle: true,
        title: Text(
          context.l10n.languageSettings,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : const Color(0xFF1E293B),
            fontSize: 18,
          ),
        ),
      ),
      body: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, currentLocale) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.selectLanguage,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.l10n.chooseLanguageSubtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode
                          ? Colors.grey.shade500
                          : Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF1E293B)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isDarkMode
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                    ),
                    child: Column(
                      children: [
                        LanguageOptionItem(
                          title: 'Bahasa Indonesia',
                          subtitle: 'Indonesia (ID)',
                          flag: '🇮🇩',
                          isSelected: currentLocale.languageCode == 'id',
                          onTap: () {
                            context.read<LocaleCubit>().setLocale(
                                  const Locale('id'),
                                );
                          },
                        ),
                        Divider(
                          height: 1,
                          color: isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade100,
                          indent: 64,
                          endIndent: 16,
                        ),
                        LanguageOptionItem(
                          title: 'English',
                          subtitle: 'United States (EN)',
                          flag: '🇺🇸',
                          isSelected: currentLocale.languageCode == 'en',
                          onTap: () {
                            context.read<LocaleCubit>().setLocale(
                                  const Locale('en'),
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
        },
      ),
    );
  }
}
