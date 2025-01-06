/// Pharmacy entity
library;

/// speacial import for nosyApi
// ignore_for_file: public_member_api_docs

class Pharmacy {
  /// Pharmacy entity constructor
  Pharmacy({
    this.pharmacyId,
    this.pharmacyName,
    this.address,
    this.city,
    this.district,
    this.town,
    this.directions,
    this.phone,
    this.phone2,
    this.pharmacyDutyStart,
    this.pharmacyDutyEnd,
    this.latitude,
    this.longitude,
    this.distanceMt,
    this.distanceKm,
    this.distanceMil,
  });

  /// Pharmacy entity from json
  Pharmacy.fromJson(Map<String, dynamic> json) {
    pharmacyId = (json['pharmacyID'] as num).toInt();
    pharmacyName = json['pharmacyName']?.toString();
    address = json['address']?.toString();
    city = json['city']?.toString();
    district = json['district'].toString();
    town = json['town'].toString();
    directions = json['directions']?.toString();
    phone = json['phone']?.toString();
    phone2 = json['phone2'].toString();
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

  int? pharmacyId;
  String? pharmacyName;
  String? address;
  String? city;
  String? district;
  String? town;
  String? directions;
  String? phone;
  String? phone2;
  String? pharmacyDutyStart;
  String? pharmacyDutyEnd;
  double? latitude;
  double? longitude;
  int? distanceMt;
  double? distanceKm;
  double? distanceMil;
}
