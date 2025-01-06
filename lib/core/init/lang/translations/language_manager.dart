import 'package:flutter/material.dart';

class LanguageManager {
  LanguageManager._init();
  static LanguageManager? _instance;

  /// Singleton Instance
  // ignore: prefer_constructors_over_static_methods
  static LanguageManager get instance => _instance ??= LanguageManager._init();

  static const localePath = 'assets/translations';

  final enLocale = const Locale('en', 'US');
  final trLocale = const Locale('tr', 'TR');

  List<Locale> get supportedLocales => [enLocale, trLocale];
}
