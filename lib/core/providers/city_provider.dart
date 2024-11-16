import 'package:flutter/material.dart';
import '../models/city.dart';
import '../services/city_service.dart';

class CityProvider with ChangeNotifier {
  final CityService _cityService = CityService();
  List<City> _cities = [];
  bool _isLoading = false;

  List<City> get cities => _cities;
  bool get isLoading => _isLoading;

  Future<void> fetchCities() async {
    _isLoading = true;
    notifyListeners();

    try {
      _cities = await _cityService.fetchCities();
    } catch (e) {
      _cities = [];
      throw Exception('Error fetching cities: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}