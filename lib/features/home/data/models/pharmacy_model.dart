import 'package:nobetcieczane/core/base/entities/pharmacy.dart';

/// PharmacyModel is a class that extends Pharmacy
class PharmacyModel extends Pharmacy {
  /// PharmacyModel constructor
  PharmacyModel({
    super.pharmacyId,
    super.pharmacyName,
    super.address,
    super.phone,
    super.city,
    super.district,
    super.town,
    super.directions,
    super.phone2,
    super.pharmacyDutyStart,
    super.pharmacyDutyEnd,
    super.latitude,
    super.longitude,
    super.distanceMt,
    super.distanceKm,
    super.distanceMil,
  });

  /// fromJson is a factory method that returns a PharmacyModel object
  PharmacyModel.fromJson(Map<String, dynamic> json) {
    pharmacyId = (json['pharmacyID'] as num).toInt();
    pharmacyName = json['pharmacyName']?.toString();
    address = json['address']?.toString();
    city = json['city']?.toString();
    district = json['district']?.toString();
    town = json['town']?.toString();
    directions = json['directions']?.toString();
    phone = json['phone']?.toString();
    phone2 = json['phone2']?.toString();
    pharmacyDutyStart = json['pharmacyDutyStart']?.toString();
    pharmacyDutyEnd = json['pharmacyDutyEnd']?.toString();
    latitude = (json['latitude'] as num).toDouble();
    longitude = (json['longitude'] as num).toDouble();
    distanceMt =
        json['distanceMt'] == null ? null : (json['distanceMt'] as num).toInt();
    distanceKm = json['distanceKm'] == null
        ? null
        : (json['distanceKm'] as num).toDouble();
    distanceMil = json['distanceMil'] == null
        ? null
        : (json['distanceMil'] as num).toDouble();
  }
}
