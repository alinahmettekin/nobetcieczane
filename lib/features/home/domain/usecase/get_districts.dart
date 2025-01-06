import 'package:fpdart/fpdart.dart';
import 'package:nobetcieczane/core/base/entities/district.dart';
import 'package:nobetcieczane/core/error/failure.dart';
import 'package:nobetcieczane/core/usecase/use_case.dart';
import 'package:nobetcieczane/features/home/domain/repository/home_repository.dart';

/// GetDistricts is a class that implements UseCase class.
/// It is used to get a list of districts.
class GetDistricts implements UseCase<List<District>, GetDistrictsParams> {
  /// GetDistricts constructor
  const GetDistricts(this.homeRepository);

  /// homeRepository using for getting districts by city.
  final HomeRepository homeRepository;

  @override
  Future<Either<Failure, List<District>>> call(
    GetDistrictsParams params,
  ) async {
    return homeRepository.getDistricts(params.citySlug);
  }
}

/// GetDistrictsParams is a class that contains parameters
/// for GetDistricts usecase.
final class GetDistrictsParams {
  /// GetDistrictsParams constructor
  GetDistrictsParams({
    required this.citySlug,
  });

  /// citySlug is using for getting districts by city.
  final String citySlug;
}
