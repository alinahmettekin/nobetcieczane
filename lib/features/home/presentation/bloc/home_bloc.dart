import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nobetcieczane/core/base/entities/city.dart';
import 'package:nobetcieczane/core/base/entities/district.dart';
import 'package:nobetcieczane/core/base/entities/pharmacy.dart';
import 'package:nobetcieczane/core/init/cache/cache_service.dart';
import 'package:nobetcieczane/core/usecase/use_case.dart';
import 'package:nobetcieczane/features/home/domain/usecase/get_cities.dart';
import 'package:nobetcieczane/features/home/domain/usecase/get_districts.dart';
import 'package:nobetcieczane/features/home/domain/usecase/get_near_pharmacies.dart';
import 'package:nobetcieczane/features/home/domain/usecase/get_pharmacies.dart';

part 'home_event.dart';
part 'home_state.dart';

/// HomeBloc is a Bloc that manages the state of the HomeView.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  /// HomeBloc constructor
  HomeBloc({
    required this.getCities,
    required this.getDistricts,
    required this.getPharmacies,
    required this.getNearPharmacies,
    required this.cacheService,
  }) : super(HomeInitial()) {
    on<HomeEvent>((_, emit) => HomeLoading());
    on<HomeGetCities>((event, emit) async {
      emit(HomeLoading());
      if (cachedCities == null) {
        final cities = await getCities(NoParams());
        cities.fold(
          (failure) => emit(HomeGetCitiesFailure(message: failure.message)),
          (cities) {
            emit(HomeGetCitiesSuccess(cities: cities));
            cachedCities = cities;
          },
        );
      } else {
        emit(HomeGetCitiesSuccess(cities: cachedCities!));
      }
    });

    on<HomeGetDistricts>((event, emit) async {
      emit(HomeLoading());
      final districts = await getDistricts(
        GetDistrictsParams(citySlug: event.citySlug),
      );
      districts.fold(
        (failure) => emit(HomeGetDistrictsFailure(message: failure.message)),
        (districts) => emit(HomeGetDistrictsSuccess(districts: districts)),
      );
    });

    on<HomeGetPharmacies>((event, emit) async {
      emit(HomeLoading());
      final pharmacies = await getPharmacies(
        GetPharmaciesParams(city: event.citySlug, district: event.districtSlug),
      );
      pharmacies.fold(
        (failure) => emit(HomeGetPharmaciesFailure(message: failure.message)),
        (pharmacies) => emit(HomeGetPharmaciesSuccess(pharmacies: pharmacies)),
      );
    });

    on<HomeGetNearPharmacies>((event, emit) async {
      emit(HomeLoading());
      if (cachedMapPharmacies == null) {
        final pharmacies = await getNearPharmacies(
          GetNearPharmaciesParams(
            latitude: event.latitude,
            longitude: event.longitude,
          ),
        );
        pharmacies.fold(
          (failure) =>
              emit(HomeGetNearPharmaciesFailure(message: failure.message)),
          (pharmacies) {
            emit(HomeGetNearPharmaciesSuccess(pharmacies: pharmacies));
            cachedMapPharmacies = pharmacies;
          },
        );
      } else {
        emit(HomeGetNearPharmaciesSuccess(pharmacies: cachedMapPharmacies!));
      }
    });

    on<HomeLoadRecentSearches>((event, emit) async {
      final searches = await cacheService.getRecentSearches();
      emit(HomeRecentSearchesLoading(searches: searches));
    });

    on<HomeSaveRecentSearch>((event, emit) async {
      final newSearch = {
        'cityName': event.cityName,
        'citySlug': event.citySlug,
        'districtName': event.districtName,
        'districtSlug': event.districtSlug,
      };

      await cacheService.saveRecentSearch(newSearch);
      final searches = await cacheService.getRecentSearches();
      emit(HomeRecentSearchesLoading(searches: searches));
    });

    on<HomeDeleteRecentSearch>((event, emit) async {
      try {
        await cacheService.deleteRecentSearch(event.search);
        final updatedSearches = await cacheService.getRecentSearches();
        emit(HomeRecentSearchesLoading(searches: updatedSearches));
      } on Exception catch (e) {
        emit(HomeDeleteRecentSearchFailure(message: e.toString()));
      }
    });

    on<HomeClearRecentSearches>((event, emit) async {
      try {
        await cacheService.clearRecentSearches();
        emit(HomeRecentSearchesLoading(searches: const []));
      } on Exception catch (e) {
        emit(HomeClearRecentSearchesFailure(message: e.toString()));
      }
    });
  }

  /// [GetCities] is a use case that returns a list of cities.
  final GetCities getCities;

  /// [GetDistricts] is a use case that returns a list of districts.
  final GetDistricts getDistricts;

  /// [GetPharmacies] is a use case that returns a list of pharmacies.
  final GetPharmacies getPharmacies;

  /// [GetNearPharmacies] is a use case that returns a list of pharmacies.
  final GetNearPharmacies getNearPharmacies;

  /// [CacheService] is a service that manages caching.
  final CacheService cacheService;

  /// cachedMapPharmacies is a variable for caching pharmacies.
  ///  For short term caching.
  List<Pharmacy>? cachedMapPharmacies;

  /// cachedCities is a variable for caching cities. For short term caching.
  List<City>? cachedCities;
}
