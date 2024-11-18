import 'package:flutter/material.dart';
import '../../core/models/room.dart';
import '../../core/services/room_service.dart';

class FavoritesProvider with ChangeNotifier {
  final RoomService _roomService = RoomService();

  List<Room> _favoriteRooms = [];
  bool _isLoading = false;

  List<Room> get favoriteRooms => _favoriteRooms;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchRooms() async {
    setLoading(true);
    List<int> roomsId = [1, 2];
    try {
      _favoriteRooms = <Room>[];
      for (var id in roomsId) {
        final completeRoom = await _roomService.fetchCompleteRoom(id);
        _favoriteRooms.add(completeRoom);
      }
    } catch (e) {
      _favoriteRooms = [];
    } finally {
      setLoading(false);
    }
  }
}
