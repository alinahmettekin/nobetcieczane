import 'package:flutter/material.dart';

class ColorSchemeLight {
  ColorSchemeLight._init();
  static ColorSchemeLight? _instace;

  /// Singleton instance of ColorSchemeLight
  // ignore: prefer_constructors_over_static_methods
  static ColorSchemeLight get instance => _instace ??= ColorSchemeLight._init();

  final Color red = const Color(0xfff44336);
  final Color blueAccent = const Color(0xff0ec1a1);
  final Color blue = const Color(0xff2196f3);
}
