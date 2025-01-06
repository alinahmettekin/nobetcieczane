part of 'init_dependencies.dart';

/// A service locator that provides dependency injection.
final serviceLocator = GetIt.instance;

/// Initializes the dependencies.
Future<void> initDependencies() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await MobileAds.instance.initialize();
  await EasyLocalization.ensureInitialized();
  FlutterNativeSplash.remove();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final sharedPreferences = await SharedPreferences.getInstance();

  serviceLocator
    ..registerSingleton<SharedPreferences>(sharedPreferences)
    ..registerSingleton<CacheService>(
      SharedPrefService(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton<HttpService>(
      () => DioServiceImpl(
        dio: serviceLocator.get<Dio>(),
      ),
    )
    ..registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      Dio.new,
    )
    ..registerSingleton(
      ThemeCubit(
        cacheService: serviceLocator.get<CacheService>(),
      ),
    );

  initHome();
}

/// Initializes the home dependencies.
void initHome() {
  serviceLocator
    ..registerFactory(
      InternetConnection.new,
    )
    ..registerFactory<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(
        dio: serviceLocator.get<HttpService>(),
      ),
    )
    ..registerFactory<HomeRepository>(
      () => HomeRepositoryImpl(
        remoteDataSource: serviceLocator(),
        connectionChecker: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetDistricts(serviceLocator()),
    )
    ..registerFactory(
      () => GetCities(serviceLocator()),
    )
    ..registerFactory(
      () => GetPharmacies(serviceLocator()),
    )
    ..registerFactory(
      () => GetNearPharmacies(serviceLocator()),
    )
    ..registerLazySingleton(
      () => HomeBloc(
        getCities: serviceLocator(),
        getDistricts: serviceLocator(),
        getPharmacies: serviceLocator(),
        getNearPharmacies: serviceLocator(),
        cacheService: serviceLocator(),
      ),
    );
}
