import 'package:fpdart/fpdart.dart';
import 'package:nobetcieczane/core/base/entities/city.dart';
import 'package:nobetcieczane/core/base/entities/district.dart';
import 'package:nobetcieczane/core/base/entities/pharmacy.dart';
import 'package:nobetcieczane/core/error/failure.dart';

/// HomeRepository is a abstract class that contains methods for
/// getting data from remote or local source.
abstract interface class HomeRepository {
  /// getCities is a method that returns a list of cities
  Future<Either<Failure, List<City>>> getCities();

  /// getDistricts is a method that returns a list of districts
  Future<Either<Failure, List<District>>> getDistricts(String city);

  /// getPharmacies is a method that returns a list of pharmacies
  Future<Either<Failure, List<Pharmacy>>> getPharmacies(
    String city,
    String district,
  );

  /// getNearPharmacies is a method that returns a list of pharmacies
  Future<Either<Failure, List<Pharmacy>>> getNearPharmacies(
    double latitude,
    double longitude,
  );
}
