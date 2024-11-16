import 'package:flutter/material.dart';
import '../models/room.dart';
import '../services/room_service.dart';

class RoomProvider with ChangeNotifier {
  final RoomService _roomService = RoomService();
  List<Room> _rooms = [];
  bool _isLoading = false;

  List<Room> get rooms => _rooms;
  bool get isLoading => _isLoading;

  Future<void> fetchRooms() async {
    _isLoading = true;
    notifyListeners();

    try {
      _rooms = await _roomService.fetchRooms();
    } catch (e) {
      _rooms = [];
      throw Exception('Error fetching rooms: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
