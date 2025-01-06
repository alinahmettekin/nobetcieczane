import 'package:nobetcieczane/core/base/entities/district.dart';

/// DistrictModel is a class that extends District
class DistrictModel extends District {
  /// DistrictModel constructor
  DistrictModel({
    required super.cities,
    required super.slug,
  });

  /// fromJson is a factory method that returns a DistrictModel object
  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      cities: json['cities'] as String,
      slug: json['slug'] as String,
    );
  }
}
