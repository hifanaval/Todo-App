import 'package:equatable/equatable.dart';
import 'package:to_do_app/core/database/app_database.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final Profile profile;

  const AuthAuthenticated(this.profile);

  @override
  List<Object?> get props => [profile];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class RegistrationSuccess extends AuthState {
  final Profile profile;

  const RegistrationSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// State for registration form with all field values and validation errors
class RegistrationFormState extends AuthState {
  final String username;
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final String dateOfBirth;
  final String? profilePicturePath;
  final DateTime? dateOfBirthDateTime;
  
  final String? usernameError;
  final String? fullNameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? dateOfBirthError;
  
  final bool isValidating;

  const RegistrationFormState({
    this.username = '',
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.dateOfBirth = '',
    this.profilePicturePath,
    this.dateOfBirthDateTime,
    this.usernameError,
    this.fullNameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.dateOfBirthError,
    this.isValidating = false,
  });

  RegistrationFormState copyWith({
    String? username,
    String? fullName,
    String? email,
    String? password,
    String? confirmPassword,
    String? dateOfBirth,
    String? profilePicturePath,
    DateTime? dateOfBirthDateTime,
    String? usernameError,
    String? fullNameError,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    String? dateOfBirthError,
    bool? isValidating,
    bool clearUsernameError = false,
    bool clearFullNameError = false,
    bool clearEmailError = false,
    bool clearPasswordError = false,
    bool clearConfirmPasswordError = false,
    bool clearDateOfBirthError = false,
  }) {
    return RegistrationFormState(
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
      dateOfBirthDateTime: dateOfBirthDateTime ?? this.dateOfBirthDateTime,
      usernameError: clearUsernameError ? null : (usernameError ?? this.usernameError),
      fullNameError: clearFullNameError ? null : (fullNameError ?? this.fullNameError),
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError: clearPasswordError ? null : (passwordError ?? this.passwordError),
      confirmPasswordError: clearConfirmPasswordError ? null : (confirmPasswordError ?? this.confirmPasswordError),
      dateOfBirthError: clearDateOfBirthError ? null : (dateOfBirthError ?? this.dateOfBirthError),
      isValidating: isValidating ?? this.isValidating,
    );
  }

  bool get isFormValid {
    return usernameError == null &&
        fullNameError == null &&
        emailError == null &&
        passwordError == null &&
        confirmPasswordError == null &&
        dateOfBirthError == null &&
        username.isNotEmpty &&
        fullName.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        dateOfBirthDateTime != null;
  }

  @override
  List<Object?> get props => [
        username,
        fullName,
        email,
        password,
        confirmPassword,
        dateOfBirth,
        profilePicturePath,
        dateOfBirthDateTime,
        usernameError,
        fullNameError,
        emailError,
        passwordError,
        confirmPasswordError,
        dateOfBirthError,
        isValidating,
      ];
}

