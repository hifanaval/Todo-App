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

