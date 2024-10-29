import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nobetcieczane/core/model/cities_model.dart';
import 'package:nobetcieczane/core/model/pharmacy_model.dart';
import 'package:nobetcieczane/core/network/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends ChangeNotifier {
  List<Cities> _cities = [];
  List<Cities> _districts = [];
  List<Pharmacy> _pharmacies = [];
  Map<String, dynamic> _getSaved = {};

  List<Cities> get cities => _cities;
  List<Cities> get districts => _districts;
  List<Pharmacy> get pharmacies => _pharmacies;
  Map<String, dynamic> get getSaved => _getSaved;

  Cities? selectedCity;
  Cities? selectedDistrict;

  bool _fillFieldValue = false;
  bool get fillFieldValue => _fillFieldValue;

  int _searchCount = 0;
  int get searchCount => _searchCount;

  void setSearchCount() {
    _searchCount++;
    if (_searchCount == 2) {
      _searchCount = 0;
    }
  }

  void deleteSavedCity(String key) {
    _getSaved.remove(key);
    saveSavedCity(_getSaved);
    notifyListeners();
  }

  String translate(String input) {
    final Map<String, String> translate = {
      'ç': 'c',
      'ş': 's',
      'ğ': 'g',
      'ü': 'u',
      'ö': 'o',
      'ı': 'i',
      'Ç': 'C',
      'Ş': 'S',
      'Ğ': 'G',
      'Ü': 'U',
      'Ö': 'O',
      'İ': 'I',
    };

    return input.split('').map((char) {
      return translate[char] ?? char;
    }).join('');
  }

  bool isExist(String city, String district) {
    String? key;
    key = (city.toString() + district.toString()).toLowerCase();

    return _getSaved.containsKey(key) ? true : false;
  }

  Future<bool> setSavedCities(String city, String district) async {
    String? key;
    key = (city.toString() + district.toString()).toLowerCase();
    final entry = <String, List<String>>{
      key: [city, district, translate(city.toLowerCase()), translate(district.toLowerCase())]
    };
    if (_getSaved.containsKey(key)) {
      return false;
    } else {
      _getSaved.addAll(entry);
      await saveSavedCity(_getSaved);
      notifyListeners();
      return true;
    }
  }

  Future<void> saveSavedCity(Map<String, dynamic> mapData) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(mapData); // Map'i JSON string'e çevir
    await prefs.setString('savedCities', jsonString);
  }

  Future<void> getSavedCity() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('savedCities');

    if (jsonString != null) {
      _getSaved = jsonDecode(jsonString) as Map<String, dynamic>;
    } else {
      return;
    }
  }

  setFillFieldValue(bool value) {
    _fillFieldValue = value;
    notifyListeners();
  }

  setSelectedCity(Cities cities) {
    selectedCity = cities;
    notifyListeners();
  }

  setSelectedDistrict(Cities cities) {
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
