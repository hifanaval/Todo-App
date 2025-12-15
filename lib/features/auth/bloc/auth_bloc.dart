import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/features/auth/bloc/auth_event.dart';
import 'package:to_do_app/features/auth/bloc/auth_state.dart';
import 'package:to_do_app/core/database/app_database.dart';
import 'package:to_do_app/features/auth/data/local_auth_source.dart';
import 'package:to_do_app/core/utils/app_utils.dart';

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
    
    // Registration form events
    on<InitializeRegistrationFormEvent>(_onInitializeRegistrationForm);
    on<UpdateUsernameEvent>(_onUpdateUsername);
    on<UpdateFullNameEvent>(_onUpdateFullName);
    on<UpdateEmailEvent>(_onUpdateEmail);
    on<UpdatePasswordEvent>(_onUpdatePassword);
    on<UpdateConfirmPasswordEvent>(_onUpdateConfirmPassword);
    on<UpdateDateOfBirthEvent>(_onUpdateDateOfBirth);
    on<UpdateProfilePictureEvent>(_onUpdateProfilePicture);
    on<ValidateRegistrationFormEvent>(_onValidateRegistrationForm);
  }

  void _onInitializeRegistrationForm(
    InitializeRegistrationFormEvent event,
    Emitter<AuthState> emit,
  ) {
    debugPrint('AuthBloc: Initializing registration form');
    emit(const RegistrationFormState());
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
    debugPrint('AuthBloc: Register event received');
    
    // Get form data from current state if it's RegistrationFormState
    String username;
    String fullName;
    String email;
    String password;
    File? profilePicture;
    DateTime? dateOfBirth;
    
    if (state is RegistrationFormState) {
      final formState = state as RegistrationFormState;
      username = formState.username.trim();
      fullName = formState.fullName.trim();
      email = formState.email.trim();
      password = formState.password;
      dateOfBirth = formState.dateOfBirthDateTime;
      profilePicture = formState.profilePicturePath != null
          ? File(formState.profilePicturePath!)
          : null;
    } else {
      // Fallback to event data (for backward compatibility)
      username = event.username;
      fullName = event.fullName;
      email = event.email;
      password = event.password;
      profilePicture = event.profilePicture;
      dateOfBirth = event.dateOfBirth;
    }
    
    debugPrint('AuthBloc: Registering user: $username');
    emit(AuthLoading());

    try {
      // Check if username already exists
      final existingProfile = await _database.getProfileByUsername(username);
      if (existingProfile != null) {
        debugPrint('AuthBloc: Username already exists');
        emit(AuthError('Username already exists'));
        return;
      }

      // Check if email already exists
      final existingEmail = await _database.getProfileByEmail(email);
      if (existingEmail != null) {
        debugPrint('AuthBloc: Email already exists');
        emit(AuthError('Email already registered'));
        return;
      }

      // Save credentials to SharedPreferences
      await LocalAuth.saveCredentials(
        email: email,
        password: password,
        rememberMe: false,
      );

      // Insert profile into database
      final profileCompanion = ProfilesCompanion.insert(
        username: username,
        fullName: fullName,
        email: email,
        password: password,
        profilePicturePath: profilePicture != null
            ? Value(profilePicture.path)
            : const Value.absent(),
        dateOfBirth: dateOfBirth != null
            ? Value(dateOfBirth)
            : const Value.absent(),
      );

      await _database.insertProfile(profileCompanion);
      final profile = await _database.getProfileByUsername(username);

      if (profile == null) {
        emit(AuthError('Failed to create profile'));
        return;
      }

      // Save additional data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('registered_username', username);
      await prefs.setString('registered_full_name', fullName);
      await prefs.setString('registered_email', email);
      if (dateOfBirth != null) {
        await prefs.setString('registered_dob', dateOfBirth.toIso8601String());
      }
      if (profilePicture != null) {
        await prefs.setString('registered_profile_picture', profilePicture.path);
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

  // Registration Form Handlers
  void _onUpdateUsername(
    UpdateUsernameEvent event,
    Emitter<AuthState> emit,
  ) {
    debugPrint('AuthBloc: Updating username: ${event.username}');
    if (state is RegistrationFormState) {
      final formState = state as RegistrationFormState;
      emit(formState.copyWith(username: event.username, clearUsernameError: true));
      _validateUsername(event.username, emit);
    }
  }

  void _onUpdateFullName(
    UpdateFullNameEvent event,
    Emitter<AuthState> emit,
  ) {
    debugPrint('AuthBloc: Updating full name: ${event.fullName}');
    if (state is RegistrationFormState) {
      final formState = state as RegistrationFormState;
      emit(formState.copyWith(fullName: event.fullName, clearFullNameError: true));
      _validateFullName(event.fullName, emit);
    }
  }

  void _onUpdateEmail(
    UpdateEmailEvent event,
    Emitter<AuthState> emit,
  ) {
    debugPrint('AuthBloc: Updating email: ${event.email}');
    if (state is RegistrationFormState) {
      final formState = state as RegistrationFormState;
      emit(formState.copyWith(email: event.email, clearEmailError: true));
      _validateEmail(event.email, emit);
    }
  }

  void _onUpdatePassword(
    UpdatePasswordEvent event,
    Emitter<AuthState> emit,
  ) {
    debugPrint('AuthBloc: Updating password');
    if (state is RegistrationFormState) {
      final formState = state as RegistrationFormState;
      emit(formState.copyWith(password: event.password, clearPasswordError: true));
      _validatePassword(event.password, emit);
      
      // Also validate confirm password if it's not empty
      if (formState.confirmPassword.isNotEmpty) {
        _validateConfirmPassword(formState.confirmPassword, event.password, emit);
      }
    }
  }

  void _onUpdateConfirmPassword(
    UpdateConfirmPasswordEvent event,
    Emitter<AuthState> emit,
  ) {
    debugPrint('AuthBloc: Updating confirm password');
    if (state is RegistrationFormState) {
      final formState = state as RegistrationFormState;
      emit(formState.copyWith(confirmPassword: event.confirmPassword, clearConfirmPasswordError: true));
      _validateConfirmPassword(event.confirmPassword, formState.password, emit);
    }
  }

  void _onUpdateDateOfBirth(
    UpdateDateOfBirthEvent event,
    Emitter<AuthState> emit,
  ) {
    debugPrint('AuthBloc: Updating date of birth: ${event.dateString}');
    if (state is RegistrationFormState) {
      final formState = state as RegistrationFormState;
      emit(formState.copyWith(
        dateOfBirth: event.dateString,
        dateOfBirthDateTime: event.dateTime,
        clearDateOfBirthError: true,
      ));
      if (event.dateTime != null) {
        emit(formState.copyWith(
          dateOfBirth: event.dateString,
          dateOfBirthDateTime: event.dateTime,
          dateOfBirthError: null,
        ));
      }
    }
  }

  void _onUpdateProfilePicture(
    UpdateProfilePictureEvent event,
    Emitter<AuthState> emit,
  ) {
    debugPrint('AuthBloc: Updating profile picture: ${event.imagePath}');
    if (state is RegistrationFormState) {
      final formState = state as RegistrationFormState;
      emit(formState.copyWith(profilePicturePath: event.imagePath));
    }
  }

  void _onValidateRegistrationForm(
    ValidateRegistrationFormEvent event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint('AuthBloc: Validating registration form');
    if (state is RegistrationFormState) {
      final formState = state as RegistrationFormState;
      
      // Validate all fields
      _validateUsername(formState.username, emit);
      _validateFullName(formState.fullName, emit);
      _validateEmail(formState.email, emit);
      _validatePassword(formState.password, emit);
      _validateConfirmPassword(formState.confirmPassword, formState.password, emit);
      
      if (formState.dateOfBirthDateTime == null) {
        if (state is RegistrationFormState) {
          final currentState = state as RegistrationFormState;
          emit(currentState.copyWith(dateOfBirthError: 'Date of birth is required'));
        }
      }
    }
  }

  // Validation Methods
  void _validateUsername(String username, Emitter<AuthState> emit) {
    if (state is! RegistrationFormState) return;
    final formState = state as RegistrationFormState;
    
    if (username.isEmpty) {
      emit(formState.copyWith(usernameError: 'Username is required'));
    } else if (username.length < 3) {
      emit(formState.copyWith(usernameError: 'Username must be at least 3 characters'));
    } else {
      // Check uniqueness asynchronously
      _checkUsernameUniqueness(username, emit);
    }
  }

  Future<void> _checkUsernameUniqueness(String username, Emitter<AuthState> emit) async {
    try {
      final existingProfile = await _database.getProfileByUsername(username);
      if (state is RegistrationFormState) {
        final formState = state as RegistrationFormState;
        if (existingProfile != null) {
          emit(formState.copyWith(usernameError: 'Username already exists'));
        } else {
          emit(formState.copyWith(usernameError: null));
        }
      }
    } catch (e) {
      debugPrint('AuthBloc: Error checking username uniqueness: $e');
    }
  }

  void _validateFullName(String fullName, Emitter<AuthState> emit) {
    if (state is! RegistrationFormState) return;
    final formState = state as RegistrationFormState;
    
    if (fullName.isEmpty) {
      emit(formState.copyWith(fullNameError: 'Full name is required'));
    } else if (fullName.trim().split(' ').length < 2) {
      emit(formState.copyWith(fullNameError: 'Please enter your full name'));
    } else {
      emit(formState.copyWith(fullNameError: null));
    }
  }

  void _validateEmail(String email, Emitter<AuthState> emit) {
    if (state is! RegistrationFormState) return;
    final formState = state as RegistrationFormState;
    
    if (email.isEmpty) {
      emit(formState.copyWith(emailError: 'Email is required'));
    } else if (!AppUtils.isValidEmail(email)) {
      emit(formState.copyWith(emailError: 'Please enter a valid email address'));
    } else {
      emit(formState.copyWith(emailError: null));
    }
  }

  void _validatePassword(String password, Emitter<AuthState> emit) {
    if (state is! RegistrationFormState) return;
    final formState = state as RegistrationFormState;
    
    if (password.isEmpty) {
      emit(formState.copyWith(passwordError: 'Password is required'));
    } else if (password.length < 6) {
      emit(formState.copyWith(passwordError: 'Password must be at least 6 characters'));
    } else {
      emit(formState.copyWith(passwordError: null));
    }
  }

  void _validateConfirmPassword(String confirmPassword, String password, Emitter<AuthState> emit) {
    if (state is! RegistrationFormState) return;
    final formState = state as RegistrationFormState;
    
    if (confirmPassword.isEmpty) {
      emit(formState.copyWith(confirmPasswordError: 'Please confirm your password'));
    } else if (confirmPassword != password) {
      emit(formState.copyWith(confirmPasswordError: 'Passwords do not match'));
    } else {
      emit(formState.copyWith(confirmPasswordError: null));
    }
  }
}

