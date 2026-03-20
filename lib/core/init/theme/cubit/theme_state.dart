part of 'theme_cubit.dart';

/// AppTheme is an enum that contains light, dark and system themes
enum AppTheme {
  /// light theme
  light,

  /// dark theme
  dark,

  /// follows the OS setting
  system,
}

/// ThemeState is a class that contains theme
@immutable
class ThemeState {
  /// ThemeState constructor
  const ThemeState({required this.theme});

  /// theme is using for changing the theme of the app.
  final AppTheme theme;

  ThemeData get lightTheme => ThemeData.light();

  ThemeData get darkTheme => ThemeData.dark();

  /// Returns the Flutter ThemeMode that matches the current [theme].
  ThemeMode get themeMode => switch (theme) {
        AppTheme.light => ThemeMode.light,
        AppTheme.dark => ThemeMode.dark,
        AppTheme.system => ThemeMode.system,
      };
}
