import 'package:nobetcieczane/core/base/entities/city.dart';

/// CityModel is a class that extends City
class CityModel extends City {
  /// CityModel constructor
  CityModel({
    required super.cities,
    required super.slug,
  });

  /// fromJson is a factory method that returns a CityModel object
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      cities: json['cities'] as String,
      slug: json['slug'] as String,
    );
  }
}
