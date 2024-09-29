import 'package:nobetcieczane/core/model/base_model.dart';

class Pharmacy extends BaseModel {
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

  Pharmacy(
      {this.pharmacyId,
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
      this.distanceMil});

  Pharmacy.fromJson(Map<String, dynamic> json) {
    pharmacyId = (json["pharmacyID"] as num).toInt();
    pharmacyName = json["pharmacyName"];
    address = json["address"];
    city = json["city"];
    district = json["district"];
    town = json["town"];
    directions = json["directions"];
    phone = json["phone"];
    phone2 = json["phone2"];
    pharmacyDutyStart = json["pharmacyDutyStart"];
    pharmacyDutyEnd = json["pharmacyDutyEnd"];
    latitude = (json["latitude"] as num).toDouble();
    longitude = (json["longitude"] as num).toDouble();
    distanceMt = json["distanceMt"] == null ? null : (json["distanceMt"] as num).toInt();
    distanceKm = json["distanceKm"] == null ? null : (json["distanceKm"] as num).toDouble();
    distanceMil = json["distanceMil"] == null ? null : (json["distanceMil"] as num).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["pharmacyID"] = pharmacyId;
    data["pharmacyName"] = pharmacyName;
    data["address"] = address;
    data["city"] = city;
    data["district"] = district;
    data["town"] = town;
    data["directions"] = directions;
    data["phone"] = phone;
    data["phone2"] = phone2;
    data["pharmacyDutyStart"] = pharmacyDutyStart;
    data["pharmacyDutyEnd"] = pharmacyDutyEnd;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    data["distanceMt"] = distanceMt;
    data["distanceKm"] = distanceKm;
    data["distanceMil"] = distanceMil;
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return Pharmacy.fromJson(json);
  }

  @override
  Map<String, dynamic> toJSon() {
    throw UnimplementedError();
  }
}
