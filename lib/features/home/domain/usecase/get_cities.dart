import 'package:fpdart/fpdart.dart';
import 'package:nobetcieczane/core/base/entities/city.dart';
import 'package:nobetcieczane/core/error/failure.dart';
import 'package:nobetcieczane/core/usecase/use_case.dart';
import 'package:nobetcieczane/features/home/domain/repository/home_repository.dart';

/// GetCities is a class that implements UseCase class.
/// It is used to get a list of cities.
class GetCities implements UseCase<List<City>, NoParams> {
  /// GetCities constructor
  const GetCities(this.homeRepository);

  /// homeRepository using for getting cities.
  final HomeRepository homeRepository;
  @override
  Future<Either<Failure, List<City>>> call(NoParams params) async {
    return homeRepository.getCities();
  }
}
