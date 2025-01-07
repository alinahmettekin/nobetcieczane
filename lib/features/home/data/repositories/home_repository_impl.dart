import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nobetcieczane/core/base/entities/city.dart';
import 'package:nobetcieczane/core/base/entities/district.dart';
import 'package:nobetcieczane/core/base/entities/pharmacy.dart';
import 'package:nobetcieczane/core/error/failure.dart';
import 'package:nobetcieczane/core/error/service_exception.dart';
import 'package:nobetcieczane/core/init/lang/translations/locale_keys.g.dart';
import 'package:nobetcieczane/core/init/network/connection_checker.dart';
import 'package:nobetcieczane/features/home/data/datasources/home_remote_data_source.dart';
import 'package:nobetcieczane/features/home/domain/repository/home_repository.dart';

/// HomeRepositoryImpl is a class that implements [HomeRepository]
class HomeRepositoryImpl implements HomeRepository {
  /// HomeRepositoryImpl constructor
  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });

  ///remoteDataSource is a final variable of type [HomeRemoteDataSource]
  final HomeRemoteDataSource remoteDataSource;

  ///connectionChecker is a final variable of type [ConnectionChecker]
  final ConnectionChecker connectionChecker;
  @override
  Future<Either<Failure, List<City>>> getCities() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(LocaleKeys.snackbar_no_internet_connection.tr()));
      }
      final cities = await remoteDataSource.getCities();
      return right(cities);
    } on Exception catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<District>>> getDistricts(String city) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(LocaleKeys.snackbar_no_internet_connection.tr()));
      }
      final districts = await remoteDataSource.getDistricts(city);
      return right(districts);
    } on ServiceException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Pharmacy>>> getPharmacies(
    String city,
    String district,
  ) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(LocaleKeys.snackbar_no_internet_connection.tr()));
      }
      final pharmacies = await remoteDataSource.getPharmacies(city, district);
      return right(pharmacies);
    } on ServiceException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Pharmacy>>> getNearPharmacies(
    double latitude,
    double longitude,
  ) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(LocaleKeys.snackbar_no_internet_connection.tr()));
      }
      final pharmacies =
          await remoteDataSource.getNearPharmacies(latitude, longitude);
      return right(pharmacies);
    } on ServiceException catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
