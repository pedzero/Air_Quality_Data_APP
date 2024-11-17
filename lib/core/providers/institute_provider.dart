import 'package:flutter/material.dart';
import '../models/institute.dart';
import '../services/institute_service.dart';

class InstituteProvider with ChangeNotifier {
  final InstituteService _instituteService = InstituteService();
  List<Institute> _institutes = [];
  bool _isLoading = false;

  List<Institute> get institutes => _institutes;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchInstitutes() async {
    _setLoading(true);

    try {
      _institutes = await _instituteService.fetchInstitutes();
    } catch (e) {
      _institutes = [];
      throw Exception('Error fetching institutes: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchInstitutesByCityId(int cityId) async {
    _setLoading(true);

    try {
      _institutes = await _instituteService.fetchInstitutesByCityId(cityId);
    } catch (e) {
      _institutes = [];
      throw Exception('Error fetching institutes from city (ID) $cityId: $e');
    } finally {
      _setLoading(false);
    }
  }
}
