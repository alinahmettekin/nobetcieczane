import 'package:eczanemnerede/core/helper/dio_helper.dart';
import 'package:eczanemnerede/core/model/cities_model.dart';
import 'package:eczanemnerede/core/model/pharmacy_model.dart';
import 'package:eczanemnerede/core/model/result_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Network extends ChangeNotifier {
  static Network? _instance;
  static Network get instance {
    return _instance ??= Network._internal();
  }

  Network._internal();

  Future<List<Cities>> getAllCitiesAndSlugs() async {
    Result result = await DioHelper.instance.dioGet('pharmacies-on-duty/cities?', Result());
    List<Cities> cities = [];

    for (var city in result.data) {
      cities.add(Cities.fromJson(city));
    }

    return cities;
  }

  Future<List<Cities>> getAllDistrictsAndSlugs(String city) async {
    Map<String, dynamic> queryParameters = {'city': city};
    Result result = await DioHelper.instance.dioGet('pharmacies-on-duty/cities?', params: queryParameters, Result());
    List<Cities> cities = [];

    for (var city in result.data) {
      cities.add(Cities.fromJson(city));
    }

    return cities;
  }

  Future<List<Pharmacy>> getNearPharmacyByLocation(LatLng location) async {
    Map<String, dynamic> queryParameters = {
      'longitude': location.longitude,
      'latitude': location.latitude,
    };
    Result result = await DioHelper.instance.dioGet('pharmacies-on-duty/locations?', params: queryParameters, Result());
    List<Pharmacy> pharmacies = [];

    for (var city in result.data) {
      pharmacies.add(Pharmacy.fromJson(city));
    }

    return pharmacies;
  }

  Future<List<Pharmacy>> getPharmacyByInformation(String city, String district) async {
    Map<String, dynamic> queryParameters = {
      'city': city,
      'district': district,
    };
    Result result = await DioHelper.instance.dioGet('pharmacies-on-duty?', params: queryParameters, Result());
    List<Pharmacy> pharmacies = [];

    for (var city in result.data) {
      pharmacies.add(Pharmacy.fromJson(city));
    }

    return pharmacies;
  }
}
