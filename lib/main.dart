import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/utils/app_utils.dart';
import 'package:to_do_app/core/theme/theme_bloc.dart';
import 'package:to_do_app/core/theme/theme_state.dart';
import 'package:to_do_app/core/theme/app_theme_data.dart';
import 'package:to_do_app/features/splash/bloc/splash_bloc.dart';
import 'package:to_do_app/features/splash/presentation/splash_screen.dart';
import 'package:to_do_app/features/auth/presentation/login_screen.dart';
import 'package:to_do_app/features/auth/presentation/registration_screen.dart';
import 'package:to_do_app/features/home/presentation/pages/home_page.dart';
import 'package:to_do_app/features/home/presentation/pages/favorites_page.dart';
import 'package:to_do_app/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:to_do_app/features/settings/presentation/pages/settings_screen.dart';
import 'package:to_do_app/features/auth/bloc/auth_bloc.dart';
import 'package:to_do_app/core/database/app_database.dart';
import 'package:to_do_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:to_do_app/features/home/data/remote/todo_remote_source.dart';
import 'package:to_do_app/features/home/data/local/todo_dao.dart';
import 'package:to_do_app/features/home/data/repository/todo_repository.dart';
import 'package:to_do_app/features/profile/bloc/profile_bloc.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Initialize unified database
    final database = AppDatabase();

    // Initialize Todo dependencies
    final httpClient = http.Client();
    final todoRemoteSource = TodoRemoteSource(httpClient);
    final todoDao = TodoDao(database);
    final todoRepository = TodoRepository(todoRemoteSource, todoDao);
    final homeBloc = HomeBloc(todoRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SplashBloc()),
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(
          create: (context) => AuthBloc(database: database),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(database: database),
        ),
        BlocProvider.value(value: homeBloc),
      ],
      child: BlocBuilder<ThemeBloc, dynamic>(
        builder: (context, themeState) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'To Do App',
        debugShowCheckedModeBanner: false,
            theme: AppThemeData.getLightTheme(),
            darkTheme: AppThemeData.getDarkTheme(),
            themeMode: themeState.theme == AppTheme.dark
                ? ThemeMode.dark
                : ThemeMode.light,
        initialRoute: AppUtils.splashRoute,
        routes: {
          AppUtils.splashRoute: (context) => const SplashScreen(),
          AppUtils.loginRoute: (context) => LoginScreen(),
          AppUtils.registrationRoute: (context) => const RegistrationScreen(),
          AppUtils.homeRoute: (context) => const HomePage(),
          AppUtils.favoritesRoute: (context) => const FavoritesPage(),
              AppUtils.editProfileRoute: (context) => const EditProfileScreen(),
              AppUtils.settingsRoute: (context) => const SettingsScreen(),
            },
            onGenerateRoute: (settings) => null,
          );
        },
      ),
    );
  }
}
