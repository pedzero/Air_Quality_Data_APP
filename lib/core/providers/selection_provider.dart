import 'package:flutter/material.dart';
import '../../core/services/city_service.dart';
import '../../core/services/institute_service.dart';
import '../../core/services/room_service.dart';
import '../../core/models/city.dart';
import '../../core/models/institute.dart';
import '../../core/models/room.dart';

class SelectionProvider with ChangeNotifier {
  final CityService _cityService = CityService();
  final InstituteService _instituteService = InstituteService();
  final RoomService _roomService = RoomService();

  List<City> _cities = [];
  List<Institute> _institutes = [];
  List<Room> _rooms = [];

  bool _isCityLoading = false;
  bool _isInstituteLoading = false;
  bool _isRoomLoading = false;

  List<City> get cities => _cities;
  List<Institute> get institutes => _institutes;
  List<Room> get rooms => _rooms;

  bool get isCityLoading => _isCityLoading;
  bool get isInstituteLoading => _isInstituteLoading;
  bool get isRoomLoading => _isRoomLoading;

  bool isPinned = false;
  bool receiveAlerts = false;

  void setPinned(bool value) {
    isPinned = value;
    notifyListeners();
  }

  void setReceiveAlerts(bool value) {
    receiveAlerts = value;
    notifyListeners();
  }

  void setCityLoading(bool value) {
    _isCityLoading = value;
    notifyListeners();
  }

  void setInstituteLoading(bool value) {
    _isInstituteLoading = value;
    notifyListeners();
  }

  void setRoomLoading(bool value) {
    _isRoomLoading = value;
    notifyListeners();
  }

  bool areSelectionsDisabled() {
    return isCityLoading || isInstituteLoading || isRoomLoading;
  }

  Future<void> fetchCities() async {
    setCityLoading(true);
    
    try {
      _cities = await _cityService.fetchCities();
    } catch (e) {
      _cities = [];
    } finally {
      setCityLoading(false);
    }
  }

  Future<void> fetchInstitutesByCityId(int cityId) async {
    setInstituteLoading(true);

    try {
      _institutes = await _instituteService.fetchInstitutesByCityId(cityId);
    } catch (e) {
      _institutes = [];
    } finally {
     setInstituteLoading(false);
    }
  }

  Future<void> fetchRoomsByInstituteId(int instituteId) async {
    setRoomLoading(true);

    try {
      _rooms = await _roomService.fetchRoomsByInstituteId(instituteId);
    } catch (e) {
      _rooms = [];
    } finally {
     setRoomLoading(false);
    }
  }
}
