import 'package:flutter/material.dart';
import '../constants/color_class.dart';
import 'theme_state.dart';

class AppThemeData {
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: ColorClass.kPrimaryColor,
        secondary: ColorClass.kAccentColor,
        surface: ColorClass.kSurfaceColor,
        background: ColorClass.kBackgroundColor,
        error: ColorClass.stateError,
      ),
      scaffoldBackgroundColor: ColorClass.kBackgroundColor,
      cardColor: ColorClass.kCardColor,
      appBarTheme: AppBarTheme(
        backgroundColor: ColorClass.kCardColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorClass.kTextColor),
        titleTextStyle: TextStyle(
          fontFamily: 'RethinkSans',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ColorClass.kTextColor,
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: ColorClass.kCardColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorClass.kCardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorClass.neutral300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorClass.neutral300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorClass.kPrimaryColor, width: 2),
        ),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: ColorClass.kPrimaryLight,
        secondary: ColorClass.kAccentColor,
        surface: const Color(0xFF1E1E1E),
        background: const Color(0xFF121212),
        error: ColorClass.stateError,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          fontFamily: 'RethinkSans',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(0xFF1E1E1E),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF404040)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF404040)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorClass.kPrimaryLight, width: 2),
        ),
      ),
    );
  }

  static ThemeData getTheme(AppTheme theme) {
    return theme == AppTheme.dark ? getDarkTheme() : getLightTheme();
  }
}

