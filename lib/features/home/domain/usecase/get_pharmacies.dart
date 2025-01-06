import 'package:fpdart/fpdart.dart';
import 'package:nobetcieczane/core/base/entities/pharmacy.dart';
import 'package:nobetcieczane/core/error/failure.dart';
import 'package:nobetcieczane/core/usecase/use_case.dart';
import 'package:nobetcieczane/features/home/domain/repository/home_repository.dart';

/// GetPharmacies is a class that implements UseCase class.
/// It is used to get a list of pharmacies by city and district.
class GetPharmacies implements UseCase<List<Pharmacy>, GetPharmaciesParams> {
  /// GetPharmacies constructor
  const GetPharmacies(this.homeRepository);

  /// homeRepository using for getting pharmacies by city and district.
  final HomeRepository homeRepository;

  @override
  Future<Either<Failure, List<Pharmacy>>> call(
    GetPharmaciesParams params,
  ) async {
    return homeRepository.getPharmacies(
      params.city,
      params.district,
    );
  }
}

/// GetPharmaciesParams is a class that contains parameters
final class GetPharmaciesParams {
  /// GetPharmaciesParams constructor
  GetPharmaciesParams({
    required this.city,
    required this.district,
  });

  /// city is using for getting pharmacies
  final String city;

  /// district is using for getting pharmacies
  final String district;
}
