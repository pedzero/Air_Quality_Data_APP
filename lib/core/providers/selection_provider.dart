import 'package:air_quality_data_app/core/services/preferences_service.dart';
import 'package:flutter/material.dart';
import '../../core/services/city_service.dart';
import '../../core/services/institute_service.dart';
import '../../core/services/room_service.dart';
import '../../core/models/city.dart';
import '../../core/models/institute.dart';
import '../../core/models/room.dart';

class SelectionProvider with ChangeNotifier {
  final _preferencesService = PreferencesService();

  final CityService _cityService = CityService();
  final InstituteService _instituteService = InstituteService();
  final RoomService _roomService = RoomService();

  List<City> _cities = [];
  List<Institute> _institutes = [];
  List<Room> _rooms = [];

  bool _isCityLoading = false;
  bool _isInstituteLoading = false;
  bool _isRoomLoading = false;

  City? _selectedCity;
  Institute? _selectedInstitute;

  List<City> get cities => _cities;
  List<Institute> get institutes => _institutes;
  List<Room> get rooms => _rooms;

  City? get selectedCity => _selectedCity;
  Institute? get selectedInstitute => _selectedInstitute;

  bool get isCityLoading => _isCityLoading;
  bool get isInstituteLoading => _isInstituteLoading;
  bool get isRoomLoading => _isRoomLoading;

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

  void setSelectedCity(City? city) {
    _selectedCity = city;
    notifyListeners();
  }

  void setSelectedInstitute(Institute? institute) {
    _selectedInstitute = institute;
    notifyListeners();
  }

  void clearRooms() {
    _rooms.clear();
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

  Future<bool> isPinnedForRoom(int roomId) async {
    return await _preferencesService.getPinnedStatusForRoom(roomId);
  }

  Future<bool> receiveAlertsForRoom(int roomId) async {
    return await _preferencesService.getNotificationForRoom(roomId);
  }

  Future<void> setPinnedForRoom(int roomId, bool value) async {
    if (value) {
      await _preferencesService.addFavoriteRoom(roomId);
    } else {
      await _preferencesService.removeFavoriteRoom(roomId);
    }
    notifyListeners();
  }

  Future<void> setNotificationForRoom(int roomId, bool value,
      String roomName) async {
    if (value) {
      await _preferencesService.addNotificationRoom(roomId, roomName);
    } else {
      await _preferencesService.removeNotificationRoom(roomId);
    }
    notifyListeners();
  }
}
