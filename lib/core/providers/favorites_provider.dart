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
  bool _refreshNeeded = false;
  bool _highlightSelection = false;

  List<Room> get favoriteRooms => _favoriteRooms;
  int get totalFavorites => _totalFavorites;
  bool get isLoading => _isLoading;
  bool get refreshNeeded => _refreshNeeded;
  bool get highlightSelection => _highlightSelection;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> checkUpdates() async {
    setLoading(true);
    final newFavoritesAmount = await getFavoritesAmount();
    _highlightSelection = false;
    _refreshNeeded = false;

    if (newFavoritesAmount != _totalFavorites) {
      _refreshNeeded = true;
    }

    final savedRoomIds = await _preferencesService.getFavoriteRoomIds();
    final savedIdsSet = savedRoomIds.toSet();

    final loadedRoomIds = _favoriteRooms.map((room) => room.id).toSet();

    if (savedIdsSet.difference(loadedRoomIds).isNotEmpty ||
        loadedRoomIds.difference(savedIdsSet).isNotEmpty) {
      _refreshNeeded = true;
    }

    if (!refreshNeeded && newFavoritesAmount == 0) {
      _highlightSelection = true;
    }

    print('refresh: $refreshNeeded');
    print('highlig: $highlightSelection');

    setLoading(false);
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
    checkUpdates();
    setLoading(false);
  }
}
