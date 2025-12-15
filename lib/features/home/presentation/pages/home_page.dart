import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:to_do_app/core/components/background_screen.dart';
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
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load initial data - shows DB data if available
    context.read<HomeBloc>().add(LoadInitialTodos());
    
    // Pagination listener
    _scrollController.addListener(() {
      if (_scrollController.hasClients &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200) {
        // Fetch more when near bottom
        context.read<HomeBloc>().add(LoadMoreTodos());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmation(int id, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: ColorClass.kCardColor,
        title: Text(
          'Delete Todo',
          style: TextStyleClass.primaryFont600(18, ColorClass.kTextColor),
        ),
        content: Text(
          'Are you sure you want to delete "$title"?',
          style: TextStyleClass.primaryFont400(14, ColorClass.kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyleClass.primaryFont500(14, ColorClass.kTextSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<HomeBloc>().add(DeleteTodo(id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorClass.stateError,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Delete',
              style: TextStyleClass.primaryFont500(14, Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      body: BackgroundPattern(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              // Todo List
              Expanded(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    // Show skeleton loader for initial load or pull-to-refresh
                    if (state.isLoading && state.todos.isEmpty) {
                      return _buildSkeletonLoader();
                    }
                    if (state.todos.isEmpty) {
                      return _buildEmptyState();
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        // Pull to refresh - reloads from page 1
                        context.read<HomeBloc>().add(RefreshTodos());
                      },
                      color: ColorClass.kPrimaryColor,
                      child: _buildTodoList(state),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildSkeletonItem();
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      ),
    );
  }

  Widget _buildSkeletonItem() {
    return Container(
      decoration: BoxDecoration(
        color: ColorClass.kCardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorClass.neutral200,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: ColorClass.neutral200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: ColorClass.neutral200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: ColorClass.neutral200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Builder(
                builder: (context) => IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: Icon(
                    Icons.menu,
                    color: ColorClass.kTextColor,
                    size: 24,
                  ),
                  tooltip: 'Menu',
                ),
              ),
              const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Todos',
                style: TextStyleClass.primaryFont700(
                  28,
                  ColorClass.kTextColor,
                ),
              ),
              const SizedBox(height: 4),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  final remaining =
                      state.todos.where((t) => !t.completed).length;
                  return Text(
                    '$remaining tasks remaining',
                    style: TextStyleClass.primaryFont400(
                      14,
                      ColorClass.kTextSecondary,
                    ),
                  );
                },
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.settings_rounded,
              color: ColorClass.kPrimaryColor,
              size: 24,
            ),
            tooltip: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    // Load profile data from local DB using email from SharedPreferences
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('HomePage: Loading profile from local DB for drawer');
      try {
        final email = await LocalAuth.email;
        if (email != null && email.isNotEmpty) {
          debugPrint('HomePage: Found email in SharedPreferences: $email');
          context.read<ProfileBloc>().add(LoadProfile(email));
        } else {
          debugPrint('HomePage: No email found in SharedPreferences');
        }
      } catch (e) {
        debugPrint('HomePage: Error loading profile: $e');
      }
    });

    return Drawer(
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          debugPrint('HomePage: Drawer ProfileBloc state: ${profileState.runtimeType}');
          
          // Show loading state
          if (profileState is ProfileLoading) {
            return Container(
              color: ColorClass.kCardColor,
              child: const Center(
                child: CircularProgressIndicator(
                  color: ColorClass.kPrimaryColor,
                ),
              ),
            );
          }

          // Show error state
          if (profileState is ProfileError) {
            return Container(
              color: ColorClass.kCardColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: ColorClass.stateError,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load profile',
                      style: TextStyleClass.primaryFont500(
                        16,
                        ColorClass.kTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profileState.message,
                      style: TextStyleClass.primaryFont400(
                        14,
                        ColorClass.kTextSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // Get profile from state
          dynamic currentProfile;
          if (profileState is ProfileLoaded) {
            currentProfile = profileState.profile;
            debugPrint('HomePage: Using ProfileLoaded state for drawer');
          } else if (profileState is ProfileUpdated) {
            currentProfile = profileState.profile;
            debugPrint('HomePage: Using ProfileUpdated state for drawer');
          } else {
            // Initial state - show loading or empty
            debugPrint('HomePage: ProfileBloc in initial state, showing loading');
            return Container(
              color: ColorClass.kCardColor,
              child: const Center(
                child: CircularProgressIndicator(
                  color: ColorClass.kPrimaryColor,
                ),
              ),
            );
          }

          // Ensure we have a valid profile
          if (currentProfile == null) {
            debugPrint('HomePage: ERROR - currentProfile is null!');
            return Container(
              color: ColorClass.kCardColor,
              child: const Center(
                child: Text('Profile not available'),
              ),
            );
          }

          int calculateCompleteness(dynamic p) {
            int completeness = 0;
            if (p.username.isNotEmpty) completeness += 33;
            if (p.profilePicturePath != null && p.profilePicturePath!.isNotEmpty) completeness += 33;
            if (p.dateOfBirth != null) completeness += 34;
            return completeness;
          }

          final completeness = calculateCompleteness(currentProfile);
          debugPrint('HomePage: Profile completeness: $completeness%');

              return Container(
                color: ColorClass.kCardColor,
                child: SafeArea(
                  child: Column(
                    children: [
                      // Profile Header
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: ColorClass.kPrimaryColor.withOpacity(0.1),
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
                                      color: ColorClass.kPrimaryColor,
                                      width: 2,
                                    ),
                                    color: ColorClass.neutral200,
                                  ),
                                  child: currentProfile.profilePicturePath != null &&
                                          currentProfile.profilePicturePath!.isNotEmpty &&
                                          File(currentProfile.profilePicturePath!).existsSync()
                                      ? ClipOval(
                                          child: Image.file(
                                            File(currentProfile.profilePicturePath!),
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              debugPrint('HomePage: Error loading profile image: $error');
                                              return Icon(
                                                Icons.person,
                                                size: 40,
                                                color: ColorClass.kTextSecondary,
                                              );
                                            },
                                          ),
                                        )
                                      : Icon(
                                          Icons.person,
                                          size: 40,
                                          color: ColorClass.kTextSecondary,
                                        ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              currentProfile.username,
                              style: TextStyleClass.primaryFont600(
                                20,
                                ColorClass.kTextColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentProfile.email,
                              style: TextStyleClass.primaryFont400(
                                14,
                                ColorClass.kTextSecondary,
                              ),
                            ),
                            if (currentProfile.dateOfBirth != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: ColorClass.kTextSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${currentProfile.dateOfBirth!.year}-${currentProfile.dateOfBirth!.month.toString().padLeft(2, '0')}-${currentProfile.dateOfBirth!.day.toString().padLeft(2, '0')}',
                                    style: TextStyleClass.primaryFont400(
                                      12,
                                      ColorClass.kTextSecondary,
                                    ),
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
                                color: ColorClass.kCardColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    size: 16,
                                    color: ColorClass.kPrimaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Profile: $completeness%',
                                    style: TextStyleClass.primaryFont500(
                                      12,
                                      ColorClass.kPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Menu Items
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.edit_outlined,
                                color: ColorClass.kPrimaryColor,
                              ),
                              title: Text(
                                'Edit Profile',
                                style: TextStyleClass.primaryFont500(
                                  16,
                                  ColorClass.kTextColor,
                                ),
                              ),
                              trailing: const Icon(Icons.chevron_right),
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
                            ListTile(
                              leading: Icon(
                                Icons.favorite_outline,
                                color: ColorClass.stateError,
                              ),
                              title: Text(
                                'Favorites',
                                style: TextStyleClass.primaryFont500(
                                  16,
                                  ColorClass.kTextColor,
                                ),
                              ),
                              trailing: const Icon(Icons.chevron_right),
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
                            ListTile(
                              leading: Icon(
                                Icons.settings_outlined,
                                color: ColorClass.kTextColor,
                              ),
                              title: Text(
                                'Settings',
                                style: TextStyleClass.primaryFont500(
                                  16,
                                  ColorClass.kTextColor,
                                ),
                              ),
                              trailing: const Icon(Icons.chevron_right),
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
                      const Divider(),

                      // Logout
                      ListTile(
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
                        onTap: () async {
                          Navigator.pop(context);
                          final shouldLogout = await AppUtils.showLogoutConfirmation(context);
                          if (shouldLogout && context.mounted) {
                            context.read<AuthBloc>().add(LogoutEvent());
                            if (context.mounted) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                AppUtils.loginRoute,
                                (route) => false,
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ColorClass.kDecorativeGreen.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline_rounded,
              size: 64,
              color: ColorClass.kPrimaryColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No todos yet!',
            style: TextStyleClass.primaryFont600(
              20,
              ColorClass.kTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pull down to refresh',
            style: TextStyleClass.primaryFont400(
              14,
              ColorClass.kTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoList(HomeState state) {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: state.todos.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.todos.length) {
          // Show loading indicator for pagination (not skeleton)
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(
                color: ColorClass.kPrimaryColor,
              ),
            ),
          );
        }
        final todo = state.todos[index];
        return _buildTodoItem(todo);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }

  Widget _buildTodoItem(todo) {
    return Dismissible(
      key: Key('todo_${todo.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: ColorClass.stateError,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (direction) {
        context.read<HomeBloc>().add(DeleteTodo(todo.id));
      },
      child: Container(
        decoration: BoxDecoration(
          color: ColorClass.kCardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: ColorClass.kDecorativeGreen.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              context.read<HomeBloc>().add(ToggleTodo(todo.id));
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Checkbox
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: todo.completed
                            ? ColorClass.kPrimaryColor
                            : ColorClass.neutral300,
                        width: 2,
                      ),
                      color: todo.completed
                          ? ColorClass.kPrimaryColor
                          : Colors.transparent,
                    ),
                    child: todo.completed
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  
                  // Todo Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Todo #${todo.id}',
                          style: TextStyleClass.primaryFont500(
                            12,
                            ColorClass.kTextLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          todo.title,
                          style: TextStyleClass.primaryFont400(
                            16,
                            todo.completed
                                ? ColorClass.kTextSecondary
                                : ColorClass.kTextColor,
                          ).copyWith(
                            decoration: todo.completed
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: ColorClass.kTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Favorite Button
                  IconButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(ToggleFavorite(todo.id));
                    },
                    icon: Icon(
                      todo.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: todo.isFavorite
                          ? ColorClass.stateError
                          : ColorClass.kTextLight,
                      size: 20,
                    ),
                    tooltip: todo.isFavorite ? 'Remove from favorites' : 'Add to favorites',
                  ),
                  
                  // Delete Button
                  IconButton(
                    onPressed: () => _showDeleteConfirmation(
                      todo.id,
                      todo.title,
                    ),
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: ColorClass.kTextLight,
                      size: 20,
                    ),
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
