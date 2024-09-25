import 'package:eczanemnerede/core/model/cities_model.dart';
import 'package:eczanemnerede/core/model/pharmacy_model.dart';
import 'package:eczanemnerede/core/network/network.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  List<Cities> _cities = [];
  List<Cities> _districts = [];
  List<Pharmacy> _pharmacies = [];

  List<Cities> get cities => _cities;
  List<Cities> get districts => _districts;
  List<Pharmacy> get pharmacies => _pharmacies;
  Cities? selectedCity;
  Cities? selectedDistrict;

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
