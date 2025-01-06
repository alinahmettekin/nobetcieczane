import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// A service class that provides caching functionality.
abstract class CacheService {
  /// Gets the theme from the cache.
  Future<bool> getTheme();

  /// Saves the theme to the cache.
  Future<void> saveTheme({required bool isDark});

  /// Gets the language from the cache.
  Future<String?> getLanguage();

  /// Saves the language to the cache.
  Future<void> saveLanguage(String languageCode, String countryCode);

  /// Gets the recent searches from the cache.
  Future<List<Map<String, String>>> getRecentSearches();

  /// Saves the recent search to the cache.
  Future<void> saveRecentSearch(Map<String, String> search);

  /// Clears the recent searches from the cache.
  Future<void> clearRecentSearches();

  /// Deletes the recent search from the cache.
  Future<void> deleteRecentSearch(Map<String, String> search);
}

/// A service class that provides caching functionality
/// using shared preferences.
class SharedPrefService implements CacheService {
  /// SharedPrefService Constructor
  SharedPrefService(this.sharedPreferences);

  /// Shared preferences instance
  final SharedPreferences sharedPreferences;

  static const String _themeKey = 'isDark';
  static const String _languageKey = 'language_code';
  static const String _countryKey = 'country_code';
  static const String _recentSearchesKey = 'recent_searches';
  static const int _maxRecentSearches = 5;

  @override
  Future<bool> getTheme() async {
    return sharedPreferences.getBool(_themeKey) ?? false;
  }

  @override
  Future<void> saveTheme({required bool isDark}) async {
    await sharedPreferences.setBool(_themeKey, isDark);
  }

  @override
  Future<String?> getLanguage() async {
    final languageCode = sharedPreferences.getString(_languageKey);
    final countryCode = sharedPreferences.getString(_countryKey);
    if (languageCode == null || countryCode == null) return null;
    return '$languageCode-$countryCode';
  }

  @override
  Future<void> saveLanguage(String languageCode, String countryCode) async {
    await sharedPreferences.setString(_languageKey, languageCode);
    await sharedPreferences.setString(_countryKey, countryCode);
  }

  @override
  Future<List<Map<String, String>>> getRecentSearches() async {
    final searches = sharedPreferences.getStringList(_recentSearchesKey) ?? [];
    return searches
        .map(
          (s) =>
              (json.decode(s) as Map<String, dynamic>).cast<String, String>(),
        )
        .toList();
  }

  @override
  Future<void> saveRecentSearch(Map<String, String> search) async {
    final searches = await getRecentSearches();

    searches
      ..removeWhere(
        (s) =>
            s['citySlug'] == search['citySlug'] &&
            s['districtSlug'] == search['districtSlug'],
      )
      ..insert(0, search);

    if (searches.length > _maxRecentSearches) {
      searches.removeRange(_maxRecentSearches, searches.length);
    }

    // SharedPreferences'a kaydet
    await sharedPreferences.setStringList(
      _recentSearchesKey,
      searches.map((s) => json.encode(s)).toList(),
    );
  }

  @override
  Future<void> clearRecentSearches() async {
    await sharedPreferences.remove(_recentSearchesKey);
  }

  @override
  Future<void> deleteRecentSearch(Map<String, String> search) async {
    final searches = await getRecentSearches();

    searches.removeWhere(
      (s) =>
          s['citySlug'] == search['citySlug'] &&
          s['districtSlug'] == search['districtSlug'],
    );

    await sharedPreferences.setStringList(
      _recentSearchesKey,
      searches.map((s) => json.encode(s)).toList(),
    );
  }
}
