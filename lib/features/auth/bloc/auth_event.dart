import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginEvent({
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  @override
  List<Object?> get props => [email, password, rememberMe];
}

class RegisterEvent extends AuthEvent {
  final String username;
  final String fullName;
  final String email;
  final String password;
  final File? profilePicture;
  final DateTime? dateOfBirth;

  const RegisterEvent({
    required this.username,
    required this.fullName,
    required this.email,
    required this.password,
    this.profilePicture,
    this.dateOfBirth,
  });

  @override
  List<Object?> get props => [
        username,
        fullName,
        email,
        password,
        profilePicture,
        dateOfBirth,
      ];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

// Registration Form Events
class InitializeRegistrationFormEvent extends AuthEvent {
  const InitializeRegistrationFormEvent();
}

class UpdateUsernameEvent extends AuthEvent {
  final String username;

  const UpdateUsernameEvent(this.username);

  @override
  List<Object?> get props => [username];
}

class UpdateFullNameEvent extends AuthEvent {
  final String fullName;

  const UpdateFullNameEvent(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

class UpdateEmailEvent extends AuthEvent {
  final String email;

  const UpdateEmailEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class UpdatePasswordEvent extends AuthEvent {
  final String password;

  const UpdatePasswordEvent(this.password);

  @override
  List<Object?> get props => [password];
}

class UpdateConfirmPasswordEvent extends AuthEvent {
  final String confirmPassword;

  const UpdateConfirmPasswordEvent(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

class UpdateDateOfBirthEvent extends AuthEvent {
  final String dateString;
  final DateTime? dateTime;

  const UpdateDateOfBirthEvent({
    required this.dateString,
    this.dateTime,
  });

  @override
  List<Object?> get props => [dateString, dateTime];
}

class UpdateProfilePictureEvent extends AuthEvent {
  final String? imagePath;

  const UpdateProfilePictureEvent(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class ValidateRegistrationFormEvent extends AuthEvent {
  const ValidateRegistrationFormEvent();
}

