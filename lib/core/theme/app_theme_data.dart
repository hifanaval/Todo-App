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
        primary: ColorClass.darkPrimary,
        secondary: ColorClass.darkSecondary,
        surface: ColorClass.darkCard,
        background: ColorClass.darkBackground,
        error: ColorClass.darkDestructive,
        onPrimary: ColorClass.darkForeground,
        onSecondary: ColorClass.darkSecondaryForeground,
        onSurface: ColorClass.darkForeground,
        onBackground: ColorClass.darkForeground,
        onError: ColorClass.darkForeground,
      ),
      scaffoldBackgroundColor: ColorClass.darkBackground,
      cardColor: ColorClass.darkCard,
      appBarTheme: AppBarTheme(
        backgroundColor: ColorClass.darkCard,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorClass.darkForeground),
        titleTextStyle: TextStyle(
          fontFamily: 'RethinkSans',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ColorClass.darkForeground,
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: ColorClass.darkCard,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorClass.darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorClass.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorClass.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorClass.darkRing, width: 2),
        ),
      ),
      dividerColor: ColorClass.darkBorder,
    );
  }

  static ThemeData getTheme(AppTheme theme) {
    return theme == AppTheme.dark ? getDarkTheme() : getLightTheme();
  }
}

