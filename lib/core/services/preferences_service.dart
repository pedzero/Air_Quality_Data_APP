import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PreferencesService {
  static const _favoritesKey = "favorites";
  static const _notificationsKey = "notifications";

  Future<void> saveFavoriteRoomIds(List<int> roomIds) async {
    final prefs = await SharedPreferences.getInstance();
    final roomIdsAsString = roomIds.map((id) => id.toString()).toList();
    await prefs.setStringList(_favoritesKey, roomIdsAsString);
  }

  Future<List<int>> getFavoriteRoomIds() async {
    final prefs = await SharedPreferences.getInstance();
    final roomIdsAsString = prefs.getStringList(_favoritesKey) ?? [];
    return roomIdsAsString.map(int.parse).toList();
  }
  
  Future<void> saveNotificationRooms(Map<int, String> rooms) async {
    final prefs = await SharedPreferences.getInstance();
    final roomsAsString = rooms.entries
        .map((entry) => jsonEncode({'id': entry.key, 'name': entry.value}))
        .toList();
    await prefs.setStringList(_notificationsKey, roomsAsString);
  }

  Future<Map<int, String>> getNotificationRooms() async {
    final prefs = await SharedPreferences.getInstance();
    final roomsAsString = prefs.getStringList(_notificationsKey) ?? [];
    final rooms = <int, String>{};
    for (var roomJson in roomsAsString) {
      final room = jsonDecode(roomJson);
      rooms[room['id']] = room['name'];
    }
    return rooms;
  }

  static Future<Map<int, String>> staticGetNotificationRooms() async {
    final prefs = await SharedPreferences.getInstance();
    final roomsAsString = prefs.getStringList(_notificationsKey) ?? [];
    final rooms = <int, String>{};
    for (var roomJson in roomsAsString) {
      final room = jsonDecode(roomJson);
      rooms[room['id']] = room['name'];
    }
    return rooms;
  }

  Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> addFavoriteRoom(int roomId) async {
    final roomIds = await getFavoriteRoomIds();
    if (!roomIds.contains(roomId)) {
      roomIds.add(roomId);
      await saveFavoriteRoomIds(roomIds);
    }
  }

  Future<void> removeFavoriteRoom(int roomId) async {
    final roomIds = await getFavoriteRoomIds();
    if (roomIds.contains(roomId)) {
      roomIds.remove(roomId);
      await saveFavoriteRoomIds(roomIds);
    }
  }

  Future<void> addNotificationRoom(int roomId, String roomName) async {
    final rooms = await getNotificationRooms();
    rooms[roomId] = roomName;
    await saveNotificationRooms(rooms);
  }

  Future<void> removeNotificationRoom(int roomId) async {
    final rooms = await getNotificationRooms();
    rooms.remove(roomId);
    await saveNotificationRooms(rooms);
  }

  Future<bool> getPinnedStatusForRoom(int roomId) async {
    final prefs = await SharedPreferences.getInstance();
    final roomIdsAsString = prefs.getStringList(_favoritesKey) ?? [];
    return roomIdsAsString.contains(roomId.toString());
  }

  Future<bool> getNotificationForRoom(int roomId) async {
    final rooms = await getNotificationRooms();
    return rooms.containsKey(roomId);
  }

  Future<int> getFavoriteRoomsAmount() async {
    final prefs = await SharedPreferences.getInstance();
    final roomIdsAsString = prefs.getStringList(_favoritesKey) ?? [];
    return roomIdsAsString.length;
  }
}
