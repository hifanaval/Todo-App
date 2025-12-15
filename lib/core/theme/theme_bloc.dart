import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'app_theme';

  ThemeBloc() : super(const ThemeState(theme: AppTheme.light)) {
    on<ThemeLoaded>(_onThemeLoaded);
    on<ThemeToggled>(_onThemeToggled);
    add(const ThemeLoaded());
  }

  Future<void> _onThemeLoaded(
    ThemeLoaded event,
    Emitter<ThemeState> emit,
  ) async {
    debugPrint('ThemeBloc: Loading theme preference');
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      final theme = AppTheme.values[themeIndex];
      debugPrint('ThemeBloc: Loaded theme: $theme');
      emit(ThemeState(theme: theme));
    } catch (e) {
      debugPrint('ThemeBloc: Error loading theme: $e');
      emit(const ThemeState(theme: AppTheme.light));
    }
  }

  Future<void> _onThemeToggled(
    ThemeToggled event,
    Emitter<ThemeState> emit,
  ) async {
    debugPrint('ThemeBloc: Toggling theme');
    try {
      final newTheme = state.theme == AppTheme.light ? AppTheme.dark : AppTheme.light;
      debugPrint('ThemeBloc: New theme: $newTheme');
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, newTheme.index);
      
      emit(ThemeState(theme: newTheme));
      debugPrint('ThemeBloc: Theme toggled successfully');
    } catch (e) {
      debugPrint('ThemeBloc: Error toggling theme: $e');
    }
  }
}

