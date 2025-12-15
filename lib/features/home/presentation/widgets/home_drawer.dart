import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/constants/color_class.dart';
import 'package:to_do_app/core/constants/textstyle_class.dart';
import 'package:to_do_app/core/utils/app_utils.dart';
import 'package:to_do_app/features/auth/bloc/auth_bloc.dart';
import 'package:to_do_app/features/auth/bloc/auth_event.dart';
import 'package:to_do_app/features/auth/data/local_auth_source.dart';
import 'package:to_do_app/features/profile/bloc/profile_bloc.dart';
import 'package:to_do_app/features/profile/bloc/profile_event.dart';
import 'package:to_do_app/features/profile/bloc/profile_state.dart';
import 'package:to_do_app/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:to_do_app/features/settings/presentation/pages/settings_screen.dart';
import '../pages/favorites_page.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Load profile data from local DB using email from SharedPreferences
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('HomeDrawer: Loading profile from local DB');
      try {
        final email = await LocalAuth.email;
        if (email != null && email.isNotEmpty) {
          debugPrint('HomeDrawer: Found email in SharedPreferences: $email');
          context.read<ProfileBloc>().add(LoadProfile(email));
        } else {
          debugPrint('HomeDrawer: No email found in SharedPreferences');
        }
      } catch (e) {
        debugPrint('HomeDrawer: Error loading profile: $e');
      }
    });

    return Drawer(
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          debugPrint('HomeDrawer: ProfileBloc state: ${profileState.runtimeType}');
          
          // Show loading state
          if (profileState is ProfileLoading) {
            return _buildLoadingState();
          }

          // Show error state
          if (profileState is ProfileError) {
            return _buildErrorState(profileState.message);
          }

          // Get profile from state
          dynamic currentProfile;
          if (profileState is ProfileLoaded) {
            currentProfile = profileState.profile;
            debugPrint('HomeDrawer: Using ProfileLoaded state');
          } else if (profileState is ProfileUpdated) {
            currentProfile = profileState.profile;
            debugPrint('HomeDrawer: Using ProfileUpdated state');
          } else {
            // Initial state - show loading
            debugPrint('HomeDrawer: ProfileBloc in initial state, showing loading');
            return _buildLoadingState();
          }

          // Ensure we have a valid profile
          if (currentProfile == null) {
            debugPrint('HomeDrawer: ERROR - currentProfile is null!');
            return _buildErrorState('Profile not available');
          }

          final completeness = _calculateCompleteness(currentProfile);
          debugPrint('HomeDrawer: Profile completeness: $completeness%');

          return _buildProfileDrawer(context, currentProfile, completeness);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        return Container(
          color: isDark ? ColorClass.darkCard : ColorClass.kCardColor,
          child: Center(
            child: CupertinoActivityIndicator(
              color: isDark ? ColorClass.darkPrimary : ColorClass.kPrimaryColor,
              radius: 16,
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        return Container(
          color: isDark ? ColorClass.darkCard : ColorClass.kCardColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: isDark ? ColorClass.darkDestructive : ColorClass.stateError,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load profile',
                  style: TextStyleClass.primaryFont500(
                    16,
                    isDark ? ColorClass.darkForeground : ColorClass.kTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: TextStyleClass.primaryFont400(
                    14,
                    isDark ? ColorClass.darkMutedForeground : ColorClass.kTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileDrawer(BuildContext context, dynamic currentProfile, int completeness) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final cardColor = isDark ? ColorClass.darkCard : ColorClass.kCardColor;
        final primaryColor = isDark ? ColorClass.darkPrimary : ColorClass.kPrimaryColor;
        final foregroundColor = isDark ? ColorClass.darkForeground : ColorClass.kTextColor;
        final secondaryColor = isDark ? ColorClass.darkMutedForeground : ColorClass.kTextSecondary;
        
        return Container(
          color: cardColor,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                // Profile Header
                _buildProfileHeader(context, currentProfile, primaryColor, foregroundColor, secondaryColor, isDark, completeness),
                
                // Menu Items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _buildMenuItem(
                        context: context,
                        icon: Icons.edit_outlined,
                        title: 'Edit Profile',
                        color: primaryColor,
                        foregroundColor: foregroundColor,
                        secondaryColor: secondaryColor,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.favorite_outline,
                        title: 'Favorites',
                        color: isDark ? ColorClass.darkFavorite : ColorClass.stateError,
                        foregroundColor: foregroundColor,
                        secondaryColor: secondaryColor,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FavoritesPage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        color: foregroundColor,
                        foregroundColor: foregroundColor,
                        secondaryColor: secondaryColor,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Divider
                Divider(
                  color: isDark ? ColorClass.darkBorder : ColorClass.neutral300,
                ),

                // Logout
                _buildLogoutTile(context, isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    dynamic currentProfile,
    Color primaryColor,
    Color foregroundColor,
    Color secondaryColor,
    bool isDark,
    int completeness,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
      ),
      child: Column(
        children: [
          // Profile Picture
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor,
                    width: 2,
                  ),
                  color: isDark ? ColorClass.darkMuted : ColorClass.neutral200,
                ),
                child: currentProfile.profilePicturePath != null &&
                        currentProfile.profilePicturePath!.isNotEmpty &&
                        File(currentProfile.profilePicturePath!).existsSync()
                    ? ClipOval(
                        child: Image.file(
                          File(currentProfile.profilePicturePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint('HomeDrawer: Error loading profile image: $error');
                            return Icon(
                              Icons.person,
                              size: 40,
                              color: secondaryColor,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 40,
                        color: secondaryColor,
                      ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            currentProfile.username,
            style: TextStyleClass.primaryFont600(20, foregroundColor),
          ),
          const SizedBox(height: 4),
          Text(
            currentProfile.email,
            style: TextStyleClass.primaryFont400(14, secondaryColor),
          ),
          if (currentProfile.dateOfBirth != null) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: secondaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  '${currentProfile.dateOfBirth!.year}-${currentProfile.dateOfBirth!.month.toString().padLeft(2, '0')}-${currentProfile.dateOfBirth!.day.toString().padLeft(2, '0')}',
                  style: TextStyleClass.primaryFont400(12, secondaryColor),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          // Profile Completeness
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isDark ? ColorClass.darkBackground : ColorClass.kCardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Profile: $completeness%',
                  style: TextStyleClass.primaryFont500(12, primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required Color foregroundColor,
    required Color secondaryColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyleClass.primaryFont500(16, foregroundColor),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: secondaryColor,
      ),
      onTap: onTap,
    );
  }

  Widget _buildLogoutTile(BuildContext context, bool isDark) {
    return ListTile(
      leading: Icon(
        Icons.logout,
        color: isDark ? ColorClass.darkDestructive : ColorClass.stateError,
      ),
      title: Text(
        'Logout',
        style: TextStyleClass.primaryFont500(
          16,
          isDark ? ColorClass.darkDestructive : ColorClass.stateError,
        ),
      ),
      onTap: () async {
        Navigator.pop(context);
        final shouldLogout = await AppUtils.showLogoutConfirmation(context);
        if (shouldLogout && context.mounted) {
          context.read<AuthBloc>().add(LogoutEvent());
          if (context.mounted) {
            // Navigate after logout - shows saved accounts if available
            await AppUtils.navigateAfterLogout(context);
          }
        }
      },
    );
  }

  int _calculateCompleteness(dynamic profile) {
    int completeness = 0;
    if (profile.username.isNotEmpty) completeness += 33;
    if (profile.profilePicturePath != null && profile.profilePicturePath!.isNotEmpty) completeness += 33;
    if (profile.dateOfBirth != null) completeness += 34;
    return completeness;
  }
}

