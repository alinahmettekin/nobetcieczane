import 'package:dio/dio.dart';
import 'package:nobetcieczane/core/error/service_exception.dart';
import 'package:nobetcieczane/core/init/network/http_service.dart';
import 'package:nobetcieczane/features/home/data/models/city_model.dart';
import 'package:nobetcieczane/features/home/data/models/district_model.dart';
import 'package:nobetcieczane/features/home/data/models/pharmacy_model.dart';

/// HomeRemoteDataSource is a abstract class that contains methods
/// to get data from remote source.
abstract interface class HomeRemoteDataSource {
  /// getCities is a method that returns a list of cities
  Future<List<CityModel>> getCities();

  /// getDistricts is a method that returns a list of districts
  Future<List<DistrictModel>> getDistricts(String city);

  /// getPharmacies is a method that returns a list of pharmacies
  ///
  Future<List<PharmacyModel>> getPharmacies(String city, String district);

  /// getNearPharmacies is a method that returns a list of pharmacies
  Future<List<PharmacyModel>> getNearPharmacies(
    double latitude,
    double longitude,
  );
}

/// HomeRemoteDataSourceImpl is a class that implements HomeRemoteDataSource
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  /// HomeRemoteDataSourceImpl constructor
  HomeRemoteDataSourceImpl({required this.dio});

  /// Dio is a final variable of type HttpService
  final HttpService dio;

  @override
  Future<List<CityModel>> getCities() async {
    try {
      final response = await dio.get('pharmacies-on-duty/cities');

      if (response.data != null && response.statusCode == 200) {
        final cities = <CityModel>[];

        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as List;

        for (final city in data) {
          cities.add(CityModel.fromJson(city as Map<String, dynamic>));
        }
        return cities;
      } else {
        throw ServiceException(message: 'Bir hata oluştu');
      }
    } on DioException catch (e) {
      throw ServiceException(message: e.message);
    } catch (e) {
      throw ServiceException(message: e.toString());
    }
  }

  @override
  Future<List<DistrictModel>> getDistricts(String city) async {
    try {
      final response = await dio.get('pharmacies-on-duty/cities?city=$city');

      if (response.data != null || response.statusCode == 200) {
        final districts = <DistrictModel>[];
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as List;
        for (final district in data) {
          districts.add(
            DistrictModel.fromJson(district as Map<String, dynamic>),
          );
        }
        return districts;
      } else {
        throw ServiceException(message: 'Bir hata oluştu');
      }
    } on DioException catch (e) {
      throw ServiceException(message: e.message);
    }
  }

  @override
  Future<List<PharmacyModel>> getPharmacies(
    String city,
    String district,
  ) async {
    try {
      final response = await dio.get(
        'pharmacies-on-duty?city=$city&district=$district',
      );

      if (response.statusCode == 200) {
        final pharmacies = <PharmacyModel>[];

        final responseMap = response.data as Map<String, dynamic>;

        if (responseMap['data'] == null) {
          return pharmacies;
        }
        final responseData = responseMap['data'] as List<dynamic>;

        for (final pharmacy in responseData) {
          pharmacies.add(
            PharmacyModel.fromJson(pharmacy as Map<String, dynamic>),
          );
        }
        return pharmacies;
      } else {
        throw ServiceException(message: 'Bir hata oluştu');
      }
    } on DioException catch (e) {
      throw ServiceException(message: e.message);
    } catch (e) {
      throw ServiceException(message: e.toString());
    }
  }

  @override
  Future<List<PharmacyModel>> getNearPharmacies(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await dio.get(
        'pharmacies-on-duty/locations?latitude=$latitude&longitude=$longitude',
      );

      if (response.statusCode == 200) {
        final pharmacies = <PharmacyModel>[];

        final responseMap = response.data as Map<String, dynamic>;

        if (responseMap['data'] == null) {
          return pharmacies;
        }
        final responseData = responseMap['data'] as List<dynamic>;

        for (final pharmacy in responseData) {
          pharmacies.add(
            PharmacyModel.fromJson(pharmacy as Map<String, dynamic>),
          );
        }
        return pharmacies;
      } else {
        throw ServiceException(message: 'Bir hata oluştu');
      }
    } on DioException catch (e) {
      throw ServiceException(message: e.message);
    } catch (e) {
      throw ServiceException(message: e.toString());
    }
  }
}
