import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/features/auth/bloc/auth_event.dart';
import 'package:to_do_app/features/auth/bloc/auth_state.dart';
import 'package:to_do_app/core/database/app_database.dart';
import 'package:to_do_app/features/auth/data/local_auth_source.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AppDatabase _database;

  AuthBloc({
    required AppDatabase database,
  })  : _database = database,
        super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint('AuthBloc: Login event received for email: ${event.email}');
    emit(AuthLoading());

    try {
      // Validate email format
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(AuthError('Email and password are required'));
        return;
      }

      // Get saved credentials from SharedPreferences
      final savedEmail = await LocalAuth.email;
      final savedPassword = await LocalAuth.password;

      if (event.email != savedEmail) {
        debugPrint('AuthBloc: Email not found');
        emit(AuthError('Email not found'));
        return;
      }

      if (event.password != savedPassword) {
        debugPrint('AuthBloc: Incorrect password');
        emit(AuthError('Incorrect password'));
        return;
      }

      // Get profile from database
      final profile = await _database.getProfileByEmail(event.email);
      if (profile == null) {
        debugPrint('AuthBloc: Profile not found in database');
        emit(AuthError('Profile not found'));
        return;
      }

      // Save remember me status
      final localAuth = LocalAuth();
      if (event.rememberMe) {
        await localAuth.setLoggedIn(true);
      } else {
        await localAuth.setLoggedIn(false);
      }

      debugPrint('AuthBloc: Login successful');
      emit(AuthAuthenticated(profile));
    } catch (e) {
      debugPrint('AuthBloc: Login error: $e');
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint('AuthBloc: Register event received for username: ${event.username}');
    emit(AuthLoading());

    try {
      // Check if username already exists
      final existingProfile = await _database.getProfileByUsername(event.username);
      if (existingProfile != null) {
        debugPrint('AuthBloc: Username already exists');
        emit(AuthError('Username already exists'));
        return;
      }

      // Check if email already exists
      final existingEmail = await _database.getProfileByEmail(event.email);
      if (existingEmail != null) {
        debugPrint('AuthBloc: Email already exists');
        emit(AuthError('Email already registered'));
        return;
      }

      // Save credentials to SharedPreferences
      await LocalAuth.saveCredentials(
        email: event.email,
        password: event.password,
        rememberMe: false,
      );

      // Insert profile into database
      final profileCompanion = ProfilesCompanion.insert(
        username: event.username,
        fullName: event.fullName,
        email: event.email,
        password: event.password,
        profilePicturePath: event.profilePicture != null
            ? Value(event.profilePicture!.path)
            : const Value.absent(),
        dateOfBirth: event.dateOfBirth != null
            ? Value(event.dateOfBirth!)
            : const Value.absent(),
      );

      await _database.insertProfile(profileCompanion);
      final profile = await _database.getProfileByUsername(event.username);

      if (profile == null) {
        emit(AuthError('Failed to create profile'));
        return;
      }

      // Save additional data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('registered_username', event.username);
      await prefs.setString('registered_full_name', event.fullName);
      await prefs.setString('registered_email', event.email);
      if (event.dateOfBirth != null) {
        await prefs.setString('registered_dob', event.dateOfBirth!.toIso8601String());
      }
      if (event.profilePicture != null) {
        await prefs.setString('registered_profile_picture', event.profilePicture!.path);
      }

      debugPrint('AuthBloc: Registration successful');
      emit(RegistrationSuccess(profile));
    } catch (e) {
      debugPrint('AuthBloc: Registration error: $e');
      emit(AuthError('Registration failed: ${e.toString()}'));
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint('AuthBloc: Logout event received');
    emit(AuthLoading());

    try {
      final localAuth = LocalAuth();
      await localAuth.setLoggedIn(false);
      debugPrint('AuthBloc: Logout successful');
      emit(AuthUnauthenticated());
    } catch (e) {
      debugPrint('AuthBloc: Logout error: $e');
      emit(AuthError('Logout failed: ${e.toString()}'));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint('AuthBloc: Checking auth status');
    emit(AuthLoading());

    try {
      final localAuth = LocalAuth();
      final isLoggedIn = await localAuth.isLoggedIn();
      if (isLoggedIn) {
        final savedEmail = await LocalAuth.email;
        if (savedEmail != null) {
          final profile = await _database.getProfileByEmail(savedEmail);
          if (profile != null) {
            debugPrint('AuthBloc: User is authenticated');
            emit(AuthAuthenticated(profile));
            return;
          }
        }
      }
      debugPrint('AuthBloc: User is not authenticated');
      emit(AuthUnauthenticated());
    } catch (e) {
      debugPrint('AuthBloc: Check auth status error: $e');
      emit(AuthUnauthenticated());
    }
  }
}

