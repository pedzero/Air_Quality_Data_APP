import 'package:flutter/material.dart';
import '../models/room.dart';
import '../services/room_service.dart';

class RoomProvider with ChangeNotifier {
  final RoomService _roomService = RoomService();
  List<Room> _rooms = [];
  bool _isLoading = false;

  List<Room> get rooms => _rooms;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchRooms() async {
    _setLoading(true);

    try {
      _rooms = await _roomService.fetchRooms();
    } catch (e) {
      _rooms = [];
      throw Exception('Error fetching rooms: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchRoomsByInstituteId(int instituteId) async {
    _setLoading(true);

    try {
      _rooms = await _roomService.fetchRoomsByInstituteId(instituteId);
    } catch (e) {
      _rooms = [];
      throw Exception('Error fetching rooms from institute (ID) $instituteId: $e');
    } finally {
      _setLoading(false);
    }
  }
}
