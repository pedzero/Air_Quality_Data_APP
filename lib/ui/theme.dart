import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class MistySeaColors {
  static const Color baseDark = Color(0xFF011C27);
  static const Color baseLight = Color(0xFFEEF0F2);

  static const List<Color> valueGradient = [
    Color(0xFF00A86B),
    Color(0xFFFFD700),
    Color(0xFFFF8C00),
    Color(0xFFDC143C),
    Color(0xFF8B008B),
  ];

  static const Color primary = Color(0xFF0E7490);
  static const Color secondary = Color(0xFF6DD5ED);
  static const Color tertiary = Color(0xFF76B041);

  static const Color textLight = Color(0xFF011C27);
  static const Color textDark = Color(0xFFFFFFFF);

  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1B2D36);

  static const Color error = Color(0xFFB00020); // Standard error red
}

class MistySeaTheme {
  static final String? fontFamily = GoogleFonts.aldrich().fontFamily;

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: MistySeaColors.primary,
        scaffoldBackgroundColor: MistySeaColors.baseLight,
        fontFamily: fontFamily,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: MistySeaColors.textLight,
          elevation: 0,
        ),
        cardTheme: const CardTheme(
          color: MistySeaColors.cardLight,
          shadowColor: Colors.black12,
          elevation: 4,
        ),
        colorScheme: const ColorScheme.light(
          primary: MistySeaColors.primary,
          secondary: MistySeaColors.secondary,
          tertiary: MistySeaColors.tertiary,
          error: MistySeaColors.error,
          surface: MistySeaColors.baseLight,
          onPrimary: Colors.white,
          onSecondary: MistySeaColors.textLight,
          onError: Colors.white,
          onSurface: MistySeaColors.textLight,
        ),
        textTheme: const TextTheme(
          displayLarge:
              TextStyle(fontSize: 57, color: MistySeaColors.textLight),
          displayMedium:
              TextStyle(fontSize: 45, color: MistySeaColors.textLight),
          displaySmall:
              TextStyle(fontSize: 36, color: MistySeaColors.textLight),
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 28),
          headlineSmall: TextStyle(fontSize: 24),
          titleLarge: TextStyle(fontSize: 22),
          titleMedium: TextStyle(fontSize: 16),
          titleSmall: TextStyle(fontSize: 14),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          bodySmall: TextStyle(fontSize: 12),
          labelLarge: TextStyle(fontSize: 14),
          labelMedium: TextStyle(fontSize: 12),
          labelSmall: TextStyle(fontSize: 10),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: MistySeaColors.primary),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MistySeaColors.secondary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MistySeaColors.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MistySeaColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MistySeaColors.error),
          ),
          floatingLabelStyle: const TextStyle(color: MistySeaColors.primary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: MistySeaColors.primary,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: MistySeaColors.primary,
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: MistySeaColors.primary,
        scaffoldBackgroundColor: MistySeaColors.baseDark,
        fontFamily: fontFamily,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: MistySeaColors.textDark,
          elevation: 0,
        ),
        cardTheme: const CardTheme(
          color: MistySeaColors.cardDark,
          shadowColor: Colors.black54,
          elevation: 4,
        ),
        colorScheme: const ColorScheme.dark(
          primary: MistySeaColors.primary,
          secondary: MistySeaColors.secondary,
          tertiary: MistySeaColors.tertiary,
          error: MistySeaColors.error,
          surface: MistySeaColors.baseDark,
          onPrimary: Colors.white,
          onSecondary: MistySeaColors.textDark,
          onError: Colors.white,
          onSurface: MistySeaColors.textDark,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 57, color: MistySeaColors.textDark),
          displayMedium:
              TextStyle(fontSize: 45, color: MistySeaColors.textDark),
          displaySmall: TextStyle(fontSize: 36, color: MistySeaColors.textDark),
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 28),
          headlineSmall: TextStyle(fontSize: 24),
          titleLarge: TextStyle(fontSize: 22),
          titleMedium: TextStyle(fontSize: 16),
          titleSmall: TextStyle(fontSize: 14),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          bodySmall: TextStyle(fontSize: 12),
          labelLarge: TextStyle(fontSize: 14),
          labelMedium: TextStyle(fontSize: 12),
          labelSmall: TextStyle(fontSize: 10),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: MistySeaColors.primary),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MistySeaColors.secondary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MistySeaColors.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MistySeaColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MistySeaColors.error),
          ),
          floatingLabelStyle: const TextStyle(color: MistySeaColors.primary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: MistySeaColors.primary,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: MistySeaColors.secondary,
          ),
        ),
      );
}
