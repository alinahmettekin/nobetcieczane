part of 'home_bloc.dart';

/// HomeEvent is a sealed class that represents the events of the HomeBloc.
@immutable
sealed class HomeState {}

/// HomeInitial is the initial state of the HomeBloc.
final class HomeInitial extends HomeState {}

/// HomeLoading is the state when the HomeBloc is on loading state.
final class HomeLoading extends HomeState {}

/// HomeGetCitiesSuccess is the state when the cities are successfully fetched.
final class HomeGetCitiesSuccess extends HomeState {
  /// HomeGetCitiesSuccess constructor
  HomeGetCitiesSuccess({
    required this.cities,
  });

  /// cities is the list of cities.
  final List<City> cities;
}

/// HomeGetCitiesFailure is the state when the cities are failed to fetch.
final class HomeGetCitiesFailure extends HomeState {
  /// HomeGetCitiesFailure constructor
  HomeGetCitiesFailure({
    required this.message,
  });

  /// message is the error message.
  final String message;
}

/// HomeGetDistrictsSuccess is the state when the districts
/// are successfully fetched.
final class HomeGetDistrictsSuccess extends HomeState {
  /// HomeGetDistrictsSuccess constructor
  HomeGetDistrictsSuccess({
    required this.districts,
  });

  /// districts is the list of districts when the districts
  /// are successfully fetched.
  final List<District> districts;
}

/// HomeGetDistrictsFailure is the state when the districts are failed to fetch.
final class HomeGetDistrictsFailure extends HomeState {
  /// HomeGetDistrictsFailure constructor
  HomeGetDistrictsFailure({
    required this.message,
  });

  /// message is the error message.
  final String message;
}

/// HomeGetPharmaciesSuccess is the state when the pharmacies
final class HomeGetPharmaciesSuccess extends HomeState {
  /// HomeGetPharmaciesSuccess constructor
  HomeGetPharmaciesSuccess({
    required this.pharmacies,
  });

  /// pharmacies is the list of pharmacies when the
  /// pharmacies are successfully fetched.
  final List<Pharmacy> pharmacies;
}

/// HomeGetPharmaciesFailure is the state when the pharmacies
/// are failed to fetch.
final class HomeGetPharmaciesFailure extends HomeState {
  /// HomeGetPharmaciesFailure constructor
  HomeGetPharmaciesFailure({
    required this.message,
  });

  /// message is the error message.
  final String message;
}

/// HomeGetNearPharmaciesSuccess is the state when the near pharmacies
final class HomeGetNearPharmaciesSuccess extends HomeState {
  /// HomeGetNearPharmaciesSuccess constructor
  HomeGetNearPharmaciesSuccess({
    required this.pharmacies,
  });

  /// pharmacies is the list of pharmacies when the search is successful.
  final List<Pharmacy> pharmacies;
}

/// HomeGetNearPharmaciesFailure is the state when the near pharmacies
final class HomeGetNearPharmaciesFailure extends HomeState {
  /// HomeGetNearPharmaciesFailure constructor
  HomeGetNearPharmaciesFailure({
    required this.message,
  });

  /// message is the error message.
  final String message;
}

/// HomeRecentSearchesSuccess is the state when the recent searches
final class HomeRecentSearchesLoading extends HomeState {
  /// HomeRecentSearchesSuccess constructor
  HomeRecentSearchesLoading({
    required this.searches,
  });

  /// searches is the list of recent searches.
  final List<Map<String, String>> searches;
}

/// HomeRecentSearchesLoadingFailure is the state when the recent searches
final class HomeRecentSearchesLoadingFailure extends HomeState {}

/// HomeSaveRecentSearchSuccess is the state when the recent search is saved.
final class HomeDeleteRecentSearchSuccess extends HomeState {
  /// HomeSaveRecentSearchSuccess constructor
  HomeDeleteRecentSearchSuccess({
    required this.updatedSearches,
  });

  /// updatedSearches is the list of updated searches.
  final List<Map<String, String>> updatedSearches;
}

/// HomeSaveRecentSearchFailure is the state when the recent
/// search is failed to save.
final class HomeDeleteRecentSearchFailure extends HomeState {
  /// HomeSaveRecentSearchFailure constructor
  HomeDeleteRecentSearchFailure({
    required this.message,
  });

  /// message is the error message.
  final String message;
}

/// HomeClearRecentSearchesSuccess is the state when the recent searches
final class HomeClearRecentSearchesFailure extends HomeState {
  /// HomeClearRecentSearchesSuccess constructor
  HomeClearRecentSearchesFailure({
    required this.message,
  });

  /// message is the error message.
  final String message;
}
