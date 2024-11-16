import 'package:flutter/material.dart';
import '../models/institute.dart';
import '../services/institute_service.dart';

class InstituteProvider with ChangeNotifier {
  final InstituteService _instituteService = InstituteService();
  List<Institute> _institutes = [];
  bool _isLoading = false;

  List<Institute> get institutes => _institutes;
  bool get isLoading => _isLoading;

  Future<void> fetchInstitutes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _institutes = await _instituteService.fetchInstitutes();
    } catch (e) {
      _institutes = [];
      throw Exception('Error fetching institutes: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
