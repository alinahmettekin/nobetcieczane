import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nobetcieczane/core/model/pharmacy_model.dart';
import 'package:nobetcieczane/core/network/network.dart';

class MapViewModel extends ChangeNotifier {
  List<Pharmacy> nearPharmacies = [];
  List<Pharmacy> allPharmacies = [];
  Set<Marker> nearPharmaciesMarkers = {};
  Set<Marker> allPharmaciesMarkers = {};
  LatLng? currenPosition;

  void setCurrentPosition(LatLng location) {
    currenPosition = LatLng(location.latitude, location.longitude);
    notifyListeners();
  }

  Future<void> getNearPharmacy(LatLng location) async {
    if (nearPharmacies.isEmpty) {
      nearPharmacies = await Network.instance.getNearPharmacyByLocation(location);
    }
    notifyListeners();
  }

  Future<void> getAllPharmacy(LatLng location) async {
    if (allPharmacies.isEmpty) {
      allPharmacies = await Network.instance.getAllPharmacyByLocation(location);
    }
    notifyListeners();
  }
}
