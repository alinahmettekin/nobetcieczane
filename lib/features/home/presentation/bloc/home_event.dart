part of 'home_bloc.dart';

/// HomeEvent is a sealed class that represents the events of the HomeBloc.
@immutable
sealed class HomeEvent {}

/// HomeGetCities is an event that is triggered when the cities are requested.
final class HomeGetCities extends HomeEvent {}

/// HomeGetDistricts is an event that is triggered when the districts are
/// requested.
final class HomeGetDistricts extends HomeEvent {
  /// HomeGetDistricts constructor
  HomeGetDistricts({
    required this.citySlug,
  });

  /// citySlug is the slug of the city.
  final String citySlug;
}

/// HomeGetPharmacies is an event that is triggered when the pharmacies are
/// requested.
final class HomeGetPharmacies extends HomeEvent {
  /// HomeGetPharmacies constructor
  HomeGetPharmacies({
    required this.citySlug,
    required this.districtSlug,
  });

  /// citySlug is the slug of the city.
  final String citySlug;

  /// districtSlug is the slug of the district.
  final String districtSlug;
}

/// HomeGetNearPharmacies is an event that is triggered when the near pharmacies
final class HomeGetNearPharmacies extends HomeEvent {
  /// HomeGetNearPharmacies constructor
  HomeGetNearPharmacies({
    required this.latitude,
    required this.longitude,
  });

  /// latitude is the latitude of the user location.
  final double latitude;

  /// longitude is the longitude of the user location.
  final double longitude;
}

/// LoadRecentSearches is an event that is triggered when the recent searches
final class HomeLoadRecentSearches extends HomeEvent {}

/// SaveRecentSearch is an event that is triggered when the recent search is
/// saved.
final class HomeSaveRecentSearch extends HomeEvent {
  /// SaveRecentSearch constructor
  HomeSaveRecentSearch({
    required this.cityName,
    required this.citySlug,
    required this.districtName,
    required this.districtSlug,
  });

  /// cityName is the name of the city.
  final String cityName;

  /// citySlug is the slug of the city.
  final String citySlug;

  /// districtName is the name of the district.
  final String districtName;

  /// districtSlug is the slug of the district.
  final String districtSlug;
}

/// HomeDeleteRecentSearch is an event that is triggered
/// when the one recent search is deleted.
final class HomeDeleteRecentSearch extends HomeEvent {
  /// HomeDeleteRecentSearch constructor
  HomeDeleteRecentSearch({
    required this.search,
  });

  /// search is the search that will be deleted.
  final Map<String, String> search;
}

/// HomeClearRecentSearches is an event that is triggered
final class HomeClearRecentSearches extends HomeEvent {}
