import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/components/background_screen.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';
import 'package:to_do_app/core/database/app_database.dart';
import 'package:to_do_app/core/utils/app_utils.dart';
import 'package:to_do_app/features/auth/bloc/auth_bloc.dart';
import 'package:to_do_app/features/auth/bloc/auth_event.dart';
import 'package:to_do_app/features/auth/bloc/auth_state.dart';
import 'package:intl/intl.dart';

class SavedAccountsScreen extends StatelessWidget {
  final List<SavedAccount> savedAccounts;

  const SavedAccountsScreen({
    super.key,
    required this.savedAccounts,
  });

  Future<void> _loginWithAccount(
    BuildContext context,
    SavedAccount account,
  ) async {
    debugPrint('SavedAccountsScreen: Logging in with account: ${account.email}');
    
    // Dispatch login event with saved account credentials
    context.read<AuthBloc>().add(LoginEvent(
      email: account.email,
      password: account.password,
      rememberMe: true, // Always true since it's a saved account
    ));
  }

  Future<void> _deleteAccount(
    BuildContext context,
    SavedAccount account,
  ) async {
    debugPrint('SavedAccountsScreen: Deleting saved account: ${account.email}');
    
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: ColorClass.kCardColor,
        title: Text(
          'Remove Account',
          style: TextStyleClass.primaryFont600(18, ColorClass.kTextColor),
        ),
        content: Text(
          'Are you sure you want to remove this account?',
          style: TextStyleClass.primaryFont400(14, ColorClass.kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyleClass.primaryFont400(
                14,
                ColorClass.kTextSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorClass.stateError,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Remove',
              style: TextStyleClass.primaryFont500(14, Colors.white),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        final database = AppDatabase();
        await database.deleteSavedAccount(account.id);
        debugPrint('SavedAccountsScreen: Account deleted successfully');
        
        // Reload the screen by navigating back and forward
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, AppUtils.splashRoute);
        }
      } catch (e) {
        debugPrint('SavedAccountsScreen: Error deleting account: $e');
        if (context.mounted) {
          AppUtils.showToast(context, message: 'Failed to remove account');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? ColorClass.darkForeground : ColorClass.kTextColor;
    final textSecondaryColor = isDark ? ColorClass.darkMutedForeground : ColorClass.kTextSecondary;
    final cardColor = isDark ? ColorClass.darkCard : ColorClass.kCardColor;
    final primaryColor = isDark ? ColorClass.darkPrimary : ColorClass.kPrimaryColor;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          debugPrint('SavedAccountsScreen: Login successful, navigating to home');
          AppUtils.showToast(context, message: 'Login successful');
          Navigator.pushReplacementNamed(context, AppUtils.homeRoute);
        } else if (state is AuthError) {
          debugPrint('SavedAccountsScreen: Login error: ${state.message}');
          AppUtils.showToast(context, message: state.message);
        }
      },
      child: Scaffold(
        body: BackgroundPattern(
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/icons/journe_icon.png',
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome Back!',
                        style: TextStyleClass.primaryFont700(28, textColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Choose an account to continue',
                        style: TextStyleClass.primaryFont400(14, textSecondaryColor),
                      ),
                    ],
                  ),
                ),

                // Saved Accounts List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: savedAccounts.length,
                    itemBuilder: (context, index) {
                      final account = savedAccounts[index];
                      return _buildAccountCard(
                        context,
                        account,
                        cardColor,
                        textColor,
                        textSecondaryColor,
                        primaryColor,
                        isDark,
                      );
                    },
                  ),
                ),

                // Login with another account button
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          debugPrint('SavedAccountsScreen: Navigating to login screen');
                          Navigator.pushReplacementNamed(context, AppUtils.loginRoute);
                        },
                        icon: const Icon(Icons.person_add_outlined),
                        label: Text(
                          'Login with another account',
                          style: TextStyleClass.primaryFont500(16, primaryColor),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryColor,
                          side: BorderSide(color: primaryColor),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard(
    BuildContext context,
    SavedAccount account,
    Color cardColor,
    Color textColor,
    Color textSecondaryColor,
    Color primaryColor,
    bool isDark,
  ) {
    final lastLogin = DateFormat('MMM dd, yyyy').format(account.lastLoginAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _loginWithAccount(context, account),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 28,
                  backgroundColor: primaryColor.withOpacity(0.1),
                  backgroundImage: account.profilePicturePath != null &&
                          File(account.profilePicturePath!).existsSync()
                      ? FileImage(File(account.profilePicturePath!))
                      : null,
                  child: account.profilePicturePath == null ||
                          !File(account.profilePicturePath!).existsSync()
                      ? Text(
                          (account.username?.substring(0, 1).toUpperCase() ??
                                  account.email.substring(0, 1).toUpperCase()),
                          style: TextStyleClass.primaryFont600(
                            20,
                            primaryColor,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),

                // Account Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.username ?? account.email.split('@')[0],
                        style: TextStyleClass.primaryFont600(16, textColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        account.email,
                        style: TextStyleClass.primaryFont400(14, textSecondaryColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Last login: $lastLogin',
                        style: TextStyleClass.primaryFont400(12, textSecondaryColor),
                      ),
                    ],
                  ),
                ),

                // Delete Button
                IconButton(
                  onPressed: () => _deleteAccount(context, account),
                  icon: Icon(
                    Icons.delete_outline,
                    color: isDark ? ColorClass.darkDestructive : ColorClass.stateError,
                  ),
                  tooltip: 'Remove account',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

