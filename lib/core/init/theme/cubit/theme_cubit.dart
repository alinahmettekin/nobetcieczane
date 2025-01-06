import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nobetcieczane/core/init/cache/cache_service.dart';

part 'theme_state.dart';

/// AppTheme is an enum that contains light and dark themes
class ThemeCubit extends Cubit<ThemeState> {
  /// ThemeCubit constructor
  ThemeCubit({
    required this.cacheService,
  }) : super(const ThemeState(theme: AppTheme.light)) {
    loadTheme();
  }

  /// cacheService is a final variable of type CacheService
  final CacheService cacheService;

  /// loadTheme is a method that loads the theme
  Future<void> loadTheme() async {
    final isDark = await cacheService.getTheme();
    emit(ThemeState(theme: isDark ? AppTheme.dark : AppTheme.light));
  }

  /// toggleTheme is a method that toggles the theme
  Future<void> toggleTheme() async {
    final newTheme =
        state.theme == AppTheme.light ? AppTheme.dark : AppTheme.light;
    await cacheService.saveTheme(isDark: newTheme == AppTheme.dark);
    emit(ThemeState(theme: newTheme));
  }
}
