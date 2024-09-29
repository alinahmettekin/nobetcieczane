import 'package:flutter/material.dart';
import 'package:nobetcieczane/core/model/cities_model.dart';
import 'package:nobetcieczane/core/model/pharmacy_model.dart';
import 'package:nobetcieczane/core/network/network.dart';

class HomeViewModel extends ChangeNotifier {
  List<Cities> _cities = [];
  List<Cities> _districts = [];
  List<Pharmacy> _pharmacies = [];

  List<Cities> get cities => _cities;
  List<Cities> get districts => _districts;
  List<Pharmacy> get pharmacies => _pharmacies;
  Cities? selectedCity;
  Cities? selectedDistrict;

  bool _fillFieldValue = false;
  bool get fillFieldValue => _fillFieldValue;

  void setFillFieldValue(bool value) {
    _fillFieldValue = value;
    notifyListeners();
  }

  void setSelectedCity(Cities cities) {
    selectedCity = cities;
    notifyListeners();
  }

  void setSelectedDistrict(Cities cities) {
    selectedDistrict = cities;
    notifyListeners();
  }

  getCities() async {
    _cities = await Network.instance.getAllCitiesAndSlugs();
    notifyListeners();
  }

  getDistrict() async {
    _districts = await Network.instance.getAllDistrictsAndSlugs(selectedCity?.slug.toString() ?? '');
    notifyListeners();
  }

  Future<void> getPharmacies(String city, String district) async {
    _pharmacies = await Network.instance.getPharmacyByInformation(city, district);
  }
}
