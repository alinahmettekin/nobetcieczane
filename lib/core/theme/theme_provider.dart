import 'package:flutter/material.dart';
import 'package:nobetcieczane/core/theme/dark_mode.dart';
import 'package:nobetcieczane/core/theme/light_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // Tema modunu kaydetme
  Future<void> saveThemeMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  // Tema modunu yükleme
  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeData = isDarkMode ? darkMode : lightMode;
    notifyListeners();
  }

  // Tema modunu değiştirme
  void toggleTheme() {
    if (_themeData == darkMode) {
      _themeData = lightMode;
      saveThemeMode(false);
    } else {
      _themeData = darkMode;
      saveThemeMode(true);
    }
    // Yeni tema kaydediliyor
    notifyListeners();
  }
}
