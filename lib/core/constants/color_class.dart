import 'package:flutter/material.dart';

class ColorClass {
  // Helper method to get theme-aware colors
  static Color getTextColor(BuildContext? context) {
    if (context == null) return kTextColor;
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkForeground : kTextColor;
  }

  static Color getTextSecondaryColor(BuildContext? context) {
    if (context == null) return kTextSecondary;
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkMutedForeground : kTextSecondary;
  }

  static Color getCardColor(BuildContext? context) {
    if (context == null) return kCardColor;
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkCard : kCardColor;
  }

  static Color getBackgroundColor(BuildContext? context) {
    if (context == null) return kBackgroundColor;
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkBackground : kBackgroundColor;
  }

  static Color getPrimaryColor(BuildContext? context) {
    if (context == null) return kPrimaryColor;
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkPrimary : kPrimaryColor;
  }

  static Color getFavoriteColor(BuildContext? context) {
    if (context == null) return stateError;
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkFavorite : stateError;
  }

  static Color getBorderColor(BuildContext? context) {
    if (context == null) return neutral300;
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkBorder : neutral300;
  }
  static const Color kPrimaryColor = Color(0xFF4A7C59); // Dark Green (like the app)
  static const Color kPrimaryLight = Color(0xFF6B9B7A); // Medium Green
  static const Color kPrimaryDark = Color(0xFF3A5F47); // Darker Green
  
  // Accent Colors - Warm Tones
  static const Color kAccentColor = Color(0xFFFFB84D); // Soft Yellow/Orange
  static const Color kAccentSecondary = Color(0xFFFFD699); // Light Yellow
  static const Color kAccentTertiary = Color(0xFFE8C4A0); // Light Beige/Orange
  
  // Background Colors - Cream and Soft Tones
  static const Color kBackgroundColor = Color(0xFFF5F1E8); // Light Cream
  static const Color kBackgroundLight = Color(0xFFFAF8F3); // Very Light Cream
  static const Color kSurfaceColor = Color(0xFFFFFDF8); // Off-White/Cream
  static const Color kCardColor = Color(0xFFFFFDF8); // Cream Cards
  
  // Text Colors
  static const Color kTextColor = Color(0xFF2D4A3E); // Dark Green (like headings)
  static const Color kTextSecondary = Color(0xFF6B7F6F); // Medium Green-Grey
  static const Color kTextLight = Color(0xFF9FAFA3); // Light Green-Grey
  
  // Decorative Colors
  static const Color kDecorativeGreen = Color(0xFFB8D4C1); // Light Green for shapes
  static const Color kDecorativeBeige = Color(0xFFE8DCC8); // Beige for shapes
  
  // Additional colors for components
  static const Color white = Colors.white;
  static const Color primary = kPrimaryColor;
  
  // Neutral colors
  static const Color neutral100 = Color(0xFFF5F5F5); // Very light grey
  static const Color neutral200 = Color(0xFFE5E5E5); // Light grey
  static const Color neutral300 = Color(0xFFD4D4D4); // Medium-light grey
  static const Color neutral500 = Color(0xFF737373); // Medium grey
  static const Color neutral700 = Color(0xFF404040); // Dark grey
  
  // State colors
  static const Color stateError = Color(0xFFDC2626); // Red for errors
  
  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF121916);
  static const Color darkForeground = Color(0xFFE7E6E2);
  static const Color darkCard = Color(0xFF1C2220);
  static const Color darkPrimary = Color(0xFF509668);
  static const Color darkSecondary = Color(0xFF2A322F);
  static const Color darkSecondaryForeground = Color(0xFFDBD9D4);
  static const Color darkMuted = Color(0xFF262B29);
  static const Color darkMutedForeground = Color(0xFF8F8E88);
  static const Color darkAccent = Color(0xFF437054);
  static const Color darkDestructive = Color(0xFFCC3333);
  static const Color darkFavorite = Color(0xFFDB4861);
  static const Color darkFavoriteMuted = Color(0xFF7A5257);
  static const Color darkSuccess = Color(0xFF339966);
  static const Color darkBorder = Color(0xFF2F3836);
  static const Color darkRing = Color(0xFF509668);
}
