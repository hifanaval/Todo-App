import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/core/database/app_database.dart';

import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AppDatabase database;

  SplashBloc({required this.database}) : super(SplashInitial()) {
    on<SplashStarted>(_onSplashStarted);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    debugPrint('SplashBloc: Starting splash initialization');
    emit(SplashLoading());

    // Initialize SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    debugPrint('SplashBloc: SharedPreferences initialized');
    
    // Simulate app startup tasks
    await Future.delayed(const Duration(seconds: 2));

    // Check if user exists (email and password stored)
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    
    debugPrint('SplashBloc: Checking user existence');
    debugPrint('SplashBloc: Email exists: ${email != null && email.isNotEmpty}');
    debugPrint('SplashBloc: Password exists: ${password != null && password.isNotEmpty}');
    debugPrint('SplashBloc: is_logged_in = $isLoggedIn');

    // Check if user exists (has email and password) and is logged in
    final hasUser = email != null && email.isNotEmpty && password != null && password.isNotEmpty;
    
    if (hasUser && isLoggedIn) {
      debugPrint('SplashBloc: User exists and is logged in, navigating to Home');
      emit(SplashAuthenticated());
    } else {
      // Check for saved accounts with remember me = true
      final savedAccounts = await database.getAllSavedAccounts();
      debugPrint('SplashBloc: Found ${savedAccounts.length} saved accounts');
      
      if (savedAccounts.isNotEmpty) {
        debugPrint('SplashBloc: Showing saved accounts screen');
        emit(SplashShowSavedAccounts(savedAccounts));
      } else {
        debugPrint('SplashBloc: No saved accounts, navigating to Login');
        emit(SplashUnauthenticated());
      }
    }
  }
}
