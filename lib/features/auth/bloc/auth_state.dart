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

