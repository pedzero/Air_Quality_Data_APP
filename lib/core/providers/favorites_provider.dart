import 'package:air_quality_data_app/core/services/preferences_service.dart';
import 'package:flutter/material.dart';
import '../../core/models/room.dart';
import '../../core/services/room_service.dart';

class FavoritesProvider with ChangeNotifier {
  final PreferencesService _preferencesService = PreferencesService();
  final RoomService _roomService = RoomService();

  List<Room> _favoriteRooms = [];
  int _totalFavorites = 0;
  bool _isLoading = false;

  List<Room> get favoriteRooms => _favoriteRooms;
  int get totalFavorites => _totalFavorites;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<int> getFavoritesAmount() async {
    setLoading(true);
    return await _preferencesService.getFavoriteRoomsAmount();
  }

  Future<void> fetchRooms() async {
    setLoading(true);
    _totalFavorites = await _preferencesService.getFavoriteRoomsAmount();
    notifyListeners();

    final roomsId = await _preferencesService.getFavoriteRoomIds();
    _favoriteRooms = [];

    for (var id in roomsId) {
      try {
        final room = await _roomService.fetchCompleteRoom(id);
        _favoriteRooms.add(room);
        notifyListeners();
      } catch (e) {
        // log
      }
    }
    setLoading(false);
  }
}
