import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuth {
  static const _emailKey = 'email';
  static const _passwordKey = 'password';
  static const _rememberMeKey = 'remember_me';
  static const _isLoggedInKey = 'is_logged_in';

  /// Get saved email from SharedPreferences
  static Future<String?> get email async {
    debugPrint('LocalAuth: Getting email from SharedPreferences');
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_emailKey);
    debugPrint('LocalAuth: Email = $email');
    return email;
  }

  /// Get saved password from SharedPreferences
  static Future<String?> get password async {
    debugPrint('LocalAuth: Getting password from SharedPreferences');
    final prefs = await SharedPreferences.getInstance();
    final password = prefs.getString(_passwordKey);
    debugPrint('LocalAuth: Password retrieved (length: ${password?.length ?? 0})');
    return password;
  }

  static Future<void> saveCredentials({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    debugPrint('LocalAuth: Saving credentials');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_passwordKey, password);
    await prefs.setBool(_rememberMeKey, rememberMe);
    debugPrint('LocalAuth: Credentials saved');
  }

  Future<bool> validateLogin(String email, String password) async {
    debugPrint('LocalAuth: Validating login');
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString(_emailKey);
    final savedPassword = prefs.getString(_passwordKey);

    final isValid = email == savedEmail && password == savedPassword;
    debugPrint('LocalAuth: Login validation result: $isValid');
    return isValid;
  }

  Future<void> setLoggedIn(bool value) async {
    debugPrint('LocalAuth: Setting is_logged_in = $value');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
}

// Keep old class name for backward compatibility
class LocalAuthSource extends LocalAuth {}
