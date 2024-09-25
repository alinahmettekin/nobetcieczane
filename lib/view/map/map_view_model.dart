import 'package:eczanemnerede/core/model/pharmacy_model.dart';
import 'package:eczanemnerede/core/network/network.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewModel extends ChangeNotifier {
  List<Pharmacy> pharmacies = [];
  Set<Marker> pharmaciesMarkers = {};
  LatLng? currenPosition;

  void setCurrentPosition(LatLng location) {
    currenPosition = LatLng(location.latitude, location.longitude);
    notifyListeners();
  }

  Future<void> getNearPharmacy(LatLng location) async {
    pharmacies = await Network.instance.getNearPharmacyByLocation(location);

    for (var pharmacy in pharmacies) {
      pharmaciesMarkers.add(
        Marker(markerId: MarkerId('${pharmacy.pharmacyId}'), position: LatLng(pharmacy.latitude!, pharmacy.longitude!)),
      );
      print(pharmacy.pharmacyName.toString());
    }

    notifyListeners();
  }
}
