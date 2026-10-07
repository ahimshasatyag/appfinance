import 'package:flutter/material.dart';

class AppTheme {
  // Definisi warna sesuai permintaan
  static const Color primaryColor = Color(0xFF0D6EFF); // warna utama
  static const Color secondaryColor = Color(0xFF0CBDE8); // warna kedua
  static const Color tertiaryColor = Color(0xFF00FFC7); // warna ketiga
  static const Color customColor = Color(0xFF0CE859); // bebas
  static const Color mixedColor = Color(0xFF1AFF00); // campur

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
      ),
      useMaterial3: true,
      
      // Tema untuk AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      
      // Tema untuk tombol
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      
      // Tema umum untuk input field
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
        floatingLabelStyle: TextStyle(color: primaryColor),
      ),
      
      // Warna untuk kursor text field
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: primaryColor,
        selectionColor: secondaryColor,
        selectionHandleColor: primaryColor,
      ),
    );
  }
}
