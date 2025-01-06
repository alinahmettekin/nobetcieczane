import 'package:fpdart/fpdart.dart';
import 'package:nobetcieczane/core/error/failure.dart';

/// UseCase is a abstract class that contains a method to call etc.
// ignore: one_member_abstracts
abstract interface class UseCase<SuccessType, Params> {
  /// call is a method that returns a Future of Either
  Future<Either<Failure, SuccessType>> call(Params params);
}

/// NoParams is a class that contains no parameters
class NoParams {}
