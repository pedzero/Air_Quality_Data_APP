import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> saveNotificationRoomIds(List<int> roomIds) async {
    final prefs = await SharedPreferences.getInstance();
    final roomIdsAsString = roomIds.map((id) => id.toString()).toList();
    await prefs.setStringList(_notificationsKey, roomIdsAsString);
  }

  Future<List<int>> getNotificationRoomIds() async {
    final prefs = await SharedPreferences.getInstance();
    final roomIdsAsString = prefs.getStringList(_notificationsKey) ?? [];
    return roomIdsAsString.map(int.parse).toList();
  }

  Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> addFavoriteRoom(int roomId) async {
    final prefs = await SharedPreferences.getInstance();
    final roomIdsAsString = prefs.getStringList(_favoritesKey) ?? [];
    roomIdsAsString.add(roomId.toString());
    await prefs.setStringList(_favoritesKey, roomIdsAsString);
  }

  Future<void> removeFavoriteRoom(int roomId) async {
    final prefs = await SharedPreferences.getInstance();
    final roomIdsAsString = prefs.getStringList(_favoritesKey) ?? [];
    roomIdsAsString.remove(roomId.toString());
    await prefs.setStringList(_favoritesKey, roomIdsAsString);
  }

  Future<void> addNotificationRoom(int roomId) async {
    final prefs = await SharedPreferences.getInstance();
    final roomIdsAsString = prefs.getStringList(_notificationsKey) ?? [];
    roomIdsAsString.add(roomId.toString());
    await prefs.setStringList(_notificationsKey, roomIdsAsString);
  }

  Future<void> removeNotificationRoom(int roomId) async {
    final prefs = await SharedPreferences.getInstance();
    final roomIdsAsString = prefs.getStringList(_notificationsKey) ?? [];
    roomIdsAsString.remove(roomId.toString());
    await prefs.setStringList(_notificationsKey, roomIdsAsString);
  }

  Future<bool> getPinnedStatusForRoom(int roomId) async {
    final prefs = await SharedPreferences.getInstance();
    final roomIdsAsString = prefs.getStringList(_favoritesKey) ?? [];
    return roomIdsAsString.contains(roomId.toString());
  }

  Future<bool> getNotificationForRoom(int roomId) async {
    final prefs = await SharedPreferences.getInstance();
    final roomIdsAsString = prefs.getStringList(_notificationsKey) ?? [];
    return roomIdsAsString.contains(roomId.toString());
  }

  Future<int> getFavoriteRoomsAmount() async {
    final prefs = await SharedPreferences.getInstance();
    final roomIdsAsString = prefs.getStringList(_favoritesKey) ?? [];
    return roomIdsAsString.length;
  }
}
