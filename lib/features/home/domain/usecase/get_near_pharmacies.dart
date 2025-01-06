import 'package:fpdart/fpdart.dart';
import 'package:nobetcieczane/core/base/entities/pharmacy.dart';
import 'package:nobetcieczane/core/error/failure.dart';
import 'package:nobetcieczane/core/usecase/use_case.dart';
import 'package:nobetcieczane/features/home/domain/repository/home_repository.dart';

/// GetNearPharmacies is a class that implements UseCase class.
/// It is used to get a list of pharmacies.
class GetNearPharmacies
    implements UseCase<List<Pharmacy>, GetNearPharmaciesParams> {
  /// GetNearPharmacies constructor
  const GetNearPharmacies(this.homeRepository);

  /// homeRepository using for getting near pharmacies by latitude and longitude
  final HomeRepository homeRepository;
  @override
  Future<Either<Failure, List<Pharmacy>>> call(
    GetNearPharmaciesParams params,
  ) async {
    return homeRepository.getNearPharmacies(
      params.latitude,
      params.longitude,
    );
  }
}

/// GetNearPharmaciesParams is a class that contains parameters
final class GetNearPharmaciesParams {
  /// GetNearPharmaciesParams constructor
  GetNearPharmaciesParams({
    required this.latitude,
    required this.longitude,
  });

  /// latitude is using for getting near pharmacies
  final double latitude;

  /// longitude is using for getting near pharmacies
  final double longitude;
}
