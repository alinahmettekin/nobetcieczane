part of 'theme_cubit.dart';

/// AppTheme is an enum that contains light and dark themes
@immutable
enum AppTheme {
  /// light theme
  light,

  /// dark theme
  dark,
}

/// ThemeState is a class that contains theme
@immutable
class ThemeState {
  /// ThemeState constructor
  const ThemeState({required this.theme});

  /// theme is using for changing the theme of the app.
  final AppTheme theme;
}
