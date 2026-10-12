import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_localizations.dart';

/// Konfigurasi dan helper untuk multi-bahasa (Localization)
class L10n {
  /// Daftar bahasa yang didukung oleh aplikasi
  static const List<Locale> supportedLocales = AppLocalizations.supportedLocales;

  /// Delegasi lokalisasi yang dibutuhkan oleh MaterialApp
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      AppLocalizations.localizationsDelegates;

  /// Default locale jika pengguna belum memilih
  static const Locale defaultLocale = Locale('id');

  /// Mendapatkan nama bahasa yang mudah dibaca berdasarkan kode bahasa
  static String getLanguageName(String code) {
    switch (code) {
      case 'id':
        return 'Bahasa Indonesia';
      case 'en':
      default:
        return 'English';
    }
  }

  /// Mendapatkan emoji bendera berdasarkan kode bahasa
  static String getFlag(String code) {
    switch (code) {
      case 'id':
        return '🇮🇩';
      case 'en':
      default:
        return '🇺🇸';
    }
  }
}

/// Helper extension untuk mengakses AppLocalizations secara praktis via context.
///
/// Contoh penggunaan:
/// ```dart
/// Text(context.l10n.income);
/// ```
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

/// Cubit untuk mengelola state bahasa aplikasi secara dinamis saat runtime.
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit([Locale? initialLocale])
      : super(initialLocale ?? L10n.defaultLocale);

  /// Mengubah bahasa aplikasi
  void setLocale(Locale locale) {
    if (!L10n.supportedLocales.contains(locale)) return;
    emit(locale);
  }

  /// Berganti bahasa antara Bahasa Indonesia ('id') dan Bahasa Inggris ('en')
  void toggleLocale() {
    emit(state.languageCode == 'id'
        ? const Locale('en')
        : const Locale('id'));
  }
}
