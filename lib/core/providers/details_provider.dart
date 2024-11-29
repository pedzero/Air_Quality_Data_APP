import 'package:flutter/material.dart';
import '../../core/models/room.dart';
import '../../core/services/room_service.dart';

class DetailsProvider with ChangeNotifier {
  final RoomService _roomService = RoomService();

  Room? _room;
  bool _isLoading = false;
  String? _errorMessage;

  Room? get room => _room;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchRoom(int roomId) async {
    setLoading(true);
    setError(null);

    try {
      _room = await _roomService.fetchCompleteRoom(roomId);
      if (_room == null) {
        setError("Sala não encontrada.");
      }
    } catch (e) {
      setError("Erro ao carregar os detalhes da sala: ${e.toString()}");
    } finally {
      setLoading(false);
    }
  }
}
