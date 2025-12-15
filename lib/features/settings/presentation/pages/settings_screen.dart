import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/core/components/background_screen.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';
import 'package:to_do_app/core/theme/theme_bloc.dart';
import 'package:to_do_app/core/theme/theme_event.dart';
import 'package:to_do_app/core/theme/theme_state.dart';
import 'package:to_do_app/core/utils/app_utils.dart';
import 'package:to_do_app/features/auth/bloc/auth_bloc.dart';
import 'package:to_do_app/features/auth/bloc/auth_event.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _clearCachedData(BuildContext context) async {
    debugPrint('SettingsScreen: Clearing cached data');
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: ColorClass.kCardColor,
        title: Text(
          'Clear Cached Data',
          style: TextStyleClass.primaryFont600(18, ColorClass.kTextColor),
        ),
        content: Text(
          'This will clear all cached data. Are you sure?',
          style: TextStyleClass.primaryFont400(14, ColorClass.kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyleClass.primaryFont500(14, ColorClass.kTextSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorClass.stateError,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Clear',
              style: TextStyleClass.primaryFont500(14, Colors.white),
            ),
          ),
        ],
      ),
    );

    if (shouldClear == true) {
      try {
        final prefs = await SharedPreferences.getInstance();
        // Clear all cached preferences except login credentials
        final email = prefs.getString('email');
        final password = prefs.getString('password');
        final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
        
        await prefs.clear();
        
        // Restore login credentials
        if (email != null && password != null) {
          await prefs.setString('email', email);
          await prefs.setString('password', password);
          await prefs.setBool('is_logged_in', isLoggedIn);
        }
        
        debugPrint('SettingsScreen: Cached data cleared successfully');
        if (context.mounted) {
          AppUtils.showToast(context, message: 'Cached data cleared');
        }
      } catch (e) {
        debugPrint('SettingsScreen: Error clearing cache: $e');
        if (context.mounted) {
          AppUtils.showToast(context, message: 'Failed to clear cache');
        }
      }
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    debugPrint('SettingsScreen: Handling logout');
    final shouldLogout = await AppUtils.showLogoutConfirmation(context);
    
    if (shouldLogout) {
      context.read<AuthBloc>().add(LogoutEvent());
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppUtils.loginRoute,
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyleClass.primaryFont600(20, ColorClass.kTextColor),
        ),
      ),
      body: BackgroundPattern(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Theme Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorClass.kCardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: TextStyleClass.primaryFont600(
                      18,
                      ColorClass.kTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                state.theme == AppTheme.dark
                                    ? Icons.dark_mode
                                    : Icons.light_mode,
                                color: ColorClass.kPrimaryColor,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Theme',
                                style: TextStyleClass.primaryFont500(
                                  16,
                                  ColorClass.kTextColor,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: state.theme == AppTheme.dark,
                            onChanged: (_) {
                              debugPrint('SettingsScreen: Toggling theme');
                              context.read<ThemeBloc>().add(const ThemeToggled());
                            },
                            activeColor: ColorClass.kPrimaryColor,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Data Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorClass.kCardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data',
                    style: TextStyleClass.primaryFont600(
                      18,
                      ColorClass.kTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.delete_outline,
                      color: ColorClass.stateError,
                    ),
                    title: Text(
                      'Clear Cached Data',
                      style: TextStyleClass.primaryFont500(
                        16,
                        ColorClass.kTextColor,
                      ),
                    ),
                    subtitle: Text(
                      'Remove temporary data and cache',
                      style: TextStyleClass.primaryFont400(
                        12,
                        ColorClass.kTextSecondary,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _clearCachedData(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Account Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorClass.kCardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account',
                    style: TextStyleClass.primaryFont600(
                      18,
                      ColorClass.kTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.logout,
                      color: ColorClass.stateError,
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyleClass.primaryFont500(
                        16,
                        ColorClass.stateError,
                      ),
                    ),
                    subtitle: Text(
                      'Sign out of your account',
                      style: TextStyleClass.primaryFont400(
                        12,
                        ColorClass.kTextSecondary,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _handleLogout(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

