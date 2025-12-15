import 'package:to_do_app/core/database/app_database.dart';

abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashAuthenticated extends SplashState {}

class SplashUnauthenticated extends SplashState {}

class SplashShowSavedAccounts extends SplashState {
  final List<SavedAccount> savedAccounts;

  SplashShowSavedAccounts(this.savedAccounts);
}
