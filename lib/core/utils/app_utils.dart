import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/core/components/toast_widget.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';
import 'package:to_do_app/core/database/app_database.dart';

// Global navigator key for accessing context from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
    BuildContext? context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    debugPrint('Showing toast: $message');
    
    // Schedule toast to show after the current frame is built
    // This ensures overlay is available when called from BLoC
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showToastInternal(context, message, duration);
    });
  }

  /// Internal method to show toast
  static void _showToastInternal(
    BuildContext? context,
    String message,
    Duration duration,
  ) {
    // Try to get overlay from navigator key first (for BLoC calls)
    OverlayState? overlay;
    
    if (context != null) {
      // Use provided context
      try {
        overlay = Overlay.of(context);
      } catch (e) {
        debugPrint('AppUtils: Cannot get overlay from provided context: $e');
      }
    }
    
    // If no overlay from context, try navigator key
    if (overlay == null) {
      final navigator = navigatorKey.currentState;
      if (navigator != null) {
        overlay = navigator.overlay;
      }
    }
    
    // If still no overlay, try getting it from navigator key's context
    if (overlay == null) {
      final ctx = navigatorKey.currentContext;
      if (ctx != null) {
        try {
          overlay = Overlay.of(ctx);
        } catch (e) {
          debugPrint('AppUtils: Cannot get overlay from navigator key context: $e');
        }
      }
    }
    
    if (overlay == null) {
      debugPrint('AppUtils: Cannot show toast - no overlay available');
      return;
    }

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => ToastWidget(
        message: message,
        onDismiss: () {
          if (entry.mounted) {
            entry.remove();
          }
        },
      ),
    );

    overlay.insert(entry);
    Future.delayed(duration, () {
      if (entry.mounted) {
        entry.remove();
      }
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

  /// Show a generic confirmation dialog
  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    Color? cancelColor,
  }) async {
    debugPrint('Showing confirmation dialog: $title');
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final cardColor = isDark ? ColorClass.darkCard : ColorClass.kCardColor;
    final textColor = isDark ? ColorClass.darkForeground : ColorClass.kTextColor;
    final textSecondaryColor = isDark ? ColorClass.darkMutedForeground : ColorClass.kTextSecondary;
    final primaryColor = confirmColor ?? (isDark ? ColorClass.darkPrimary : ColorClass.kPrimaryColor);
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: cardColor,
        title: Text(
          title,
          style: TextStyleClass.primaryFont600(18, textColor),
        ),
        content: Text(
          message,
          style: TextStyleClass.primaryFont400(14, textSecondaryColor),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(
              cancelText,
              style: TextStyleClass.primaryFont500(14, textSecondaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(
              confirmText,
              style: TextStyleClass.primaryFont500(14, Colors.white),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Show delete confirmation dialog
  static Future<bool> showDeleteConfirmation({
    required BuildContext context,
    required String itemName,
  }) async {
    debugPrint('Showing delete confirmation for: $itemName');
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return showConfirmationDialog(
      context: context,
      title: 'Delete Todo',
      message: 'Are you sure you want to delete "$itemName"?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      confirmColor: isDark ? ColorClass.darkDestructive : ColorClass.stateError,
    );
  }

  /// Show logout confirmation dialog
  static Future<bool> showLogoutConfirmation(BuildContext context) async {
    debugPrint('Showing logout confirmation dialog');
    return showConfirmationDialog(
      context: context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
    );
  }

  /// Navigate after logout - shows saved accounts if available, otherwise login screen
  static Future<void> navigateAfterLogout(BuildContext context) async {
    debugPrint('AppUtils: Navigating after logout');
    try {
      final database = AppDatabase();
      final savedAccounts = await database.getAllSavedAccounts();
      debugPrint('AppUtils: Found ${savedAccounts.length} saved accounts after logout');
      
      if (savedAccounts.isNotEmpty) {
        debugPrint('AppUtils: Showing saved accounts screen');
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/saved-accounts',
          (route) => false,
          arguments: savedAccounts,
        );
      } else {
        debugPrint('AppUtils: No saved accounts, navigating to login');
        Navigator.of(context).pushNamedAndRemoveUntil(
          loginRoute,
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('AppUtils: Error checking saved accounts: $e');
      // Fallback to login screen
      Navigator.of(context).pushNamedAndRemoveUntil(
        loginRoute,
        (route) => false,
      );
    }
  }
}




