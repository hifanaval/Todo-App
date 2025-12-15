import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/core/components/toast_widget.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';

class AppUtils {
  // Route names
  static const String splashRoute = '/splash';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String homeRoute = '/home';
  static const String registrationRoute = '/registration';
  static const String favoritesRoute = '/favorites';
  static const String editProfileRoute = '/edit-profile';
  static const String settingsRoute = '/settings';

  /// Navigate to a screen using named routes
  /// Takes a widget and navigates to it using the corresponding route name
  static void navigateTo(BuildContext context, Widget widget) {
    debugPrint('Navigating to widget: ${widget.runtimeType}');
    
    // Get route name based on widget type
    String routeName = _getRouteNameForWidget(widget);
    
    // Navigate using named route
    Navigator.pushNamed(context, routeName);
  }

  /// Push a named route onto the navigation stack
  /// This is for normal navigation (can go back)
  static Future<T?> pushNamed<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    debugPrint('Pushing named route: $routeName with arguments: $arguments');
    return Navigator.pushNamed<T>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Get route name for a widget type
  static String _getRouteNameForWidget(Widget widget) {
    final widgetType = widget.runtimeType.toString();
    debugPrint('Getting route name for widget type: $widgetType');
    
    // Map widget types to route names
    switch (widgetType) {
      case 'SplashScreen':
        return splashRoute;
      case 'LoginScreen':
        return loginRoute;
      case 'SignupScreen':
        return signupRoute;
      case 'HomeScreen':
        return homeRoute;
      case 'RegistrationScreen':
        return registrationRoute;
      default:
        // For unknown widgets, use a generic route name
        debugPrint('Warning: Unknown widget type $widgetType, using default route');
        return '/${widgetType.toLowerCase()}';
    }
  }

  /// Show a toast message
  static void showToast(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    debugPrint('Showing toast: $message');
    final overlay = Overlay.of(context);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => ToastWidget(
        message: message,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
    Future.delayed(duration, () {
      entry.remove();
    });
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    debugPrint('Validating email format: $email');
    // Email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    final isValid = emailRegex.hasMatch(email);
    debugPrint('Email validation result: $isValid');
    return isValid;
  }

  /// Show logout confirmation dialog
  static Future<bool> showLogoutConfirmation(BuildContext context) async {
    debugPrint('Showing logout confirmation dialog');
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: ColorClass.kCardColor,
        title: Text(
          'Logout',
          style: TextStyleClass.primaryFont600(18, ColorClass.kTextColor),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyleClass.primaryFont400(14, ColorClass.kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(
              'Cancel',
              style: TextStyleClass.primaryFont500(14, ColorClass.kTextSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorClass.kPrimaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Logout',
              style: TextStyleClass.primaryFont500(14, Colors.white),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}




