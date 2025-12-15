import 'package:equatable/equatable.dart';

enum AppTheme { light, dark }

class ThemeState extends Equatable {
  final AppTheme theme;

  const ThemeState({required this.theme});

  @override
  List<Object?> get props => [theme];

  ThemeState copyWith({AppTheme? theme}) {
    return ThemeState(theme: theme ?? this.theme);
  }
}

