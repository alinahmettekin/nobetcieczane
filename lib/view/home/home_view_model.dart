import 'dart:convert';
import 'dart:developer';

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
  List<String> _lastSearch = [];
  bool _isLastSearch = false;

  List<Cities> get cities => _cities;
  List<Cities> get districts => _districts;
  List<Pharmacy> get pharmacies => _pharmacies;
  Map<String, dynamic> get getSaved => _getSaved;
  List<String> get lastSearch => _lastSearch;
  bool get isLastSearch => _isLastSearch;

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

  setIsLastSearch() {
    _isLastSearch = !_isLastSearch;
    notifyListeners();
  }

  setFillFieldValue(bool value) {
    _fillFieldValue = value;
    notifyListeners();
  }

  setSelectedCity(Cities cities) {
    selectedCity = cities;
    selectedDistrict = null;
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

  void getDistrict() async {
    _districts.clear();
    _districts = await Network.instance.getAllDistrictsAndSlugs(selectedCity?.slug.toString() ?? '');
    notifyListeners();
  }

  Future<void> getPharmacies(String city, String district) async {
    _pharmacies = await Network.instance.getPharmacyByInformation(city, district);
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

  Future<void> setLastSearch(String city, String district) async {
    final prefs = await SharedPreferences.getInstance();
    _lastSearch = [city, district, translate(city.toLowerCase()), translate(district.toLowerCase())];
    await prefs.setStringList('lastSearch', _lastSearch);
  }

  Future<void> getLastSearch() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? prefList = prefs.getStringList('lastSearch');

    if (prefList == null) {
      log("kanki veri null geldi");
      return;
    }

    Cities city = Cities();
    Cities district = Cities();
    city.cities = prefList[0];
    city.slug = prefList[2];

    district.cities = prefList[1];
    district.slug = prefList[3];

    selectedCity = city;
    selectedDistrict = district;

    _isLastSearch = true;
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

  void deleteSavedCity(String key) {
    _getSaved.remove(key);
    saveSavedCity(_getSaved);
    notifyListeners();
  }

  bool isExist(String city, String district) {
    String? key;
    key = (city.toString() + district.toString()).toLowerCase();

    return _getSaved.containsKey(key) ? true : false;
  }
}
