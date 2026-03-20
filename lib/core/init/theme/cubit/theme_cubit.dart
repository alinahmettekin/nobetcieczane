import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nobetcieczane/core/init/cache/cache_service.dart';

part 'theme_state.dart';

/// ThemeCubit manages the app theme with three modes:
/// [AppTheme.light], [AppTheme.dark], and [AppTheme.system].
///
/// - On first launch (no saved preference) → system mode.
/// - When the user manually toggles → preference is saved and respected.
/// - When the user resets → preference is cleared and system mode resumes.
class ThemeCubit extends Cubit<ThemeState> {
  /// ThemeCubit constructor
  ThemeCubit({
    required this.cacheService,
  }) : super(const ThemeState(theme: AppTheme.system)) {
    loadTheme();
  }

  /// cacheService is a final variable of type CacheService
  final CacheService cacheService;

  /// Loads the saved theme preference. Falls back to [AppTheme.system] when
  /// no preference has been stored yet.
  Future<void> loadTheme() async {
    final isDark = await cacheService.getTheme(); // null = no preference
    if (isDark == null) {
      emit(const ThemeState(theme: AppTheme.system));
    } else {
      emit(ThemeState(theme: isDark ? AppTheme.dark : AppTheme.light));
    }
  }

  /// Explicitly sets the theme to [AppTheme.light] or [AppTheme.dark] and
  /// saves the preference so the system setting is no longer followed.
  Future<void> setTheme(AppTheme theme) async {
    assert(theme != AppTheme.system, 'Use resetToSystem() to follow the OS.');
    await cacheService.saveTheme(isDark: theme == AppTheme.dark);
    emit(ThemeState(theme: theme));
  }

  /// Toggles between light and dark. If the current mode is system, it reads
  /// the actual platform brightness to decide which direction to toggle.
  Future<void> toggleTheme() async {
    final current = state.theme;
    final nextTheme = current == AppTheme.light ? AppTheme.dark : AppTheme.light;
    await setTheme(nextTheme);
  }

  /// Clears the saved preference so the app follows the OS theme again.
  Future<void> resetToSystem() async {
    await cacheService.clearTheme();
    emit(const ThemeState(theme: AppTheme.system));
  }
}
