import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/room.dart';

class RoomService {
  final String baseUrl = dotenv.env['API_URL'].toString();

  Future<List<Room>> fetchRooms() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/rooms'));
      
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Room.fromJSON(json)).toList();
      } else {
        throw Exception('Failed to load rooms');
      }
    } catch (e) {
      throw Exception('Error fetching rooms: $e');
    }
  }

  Future<List<Room>> fetchRoomsByInstituteId(int instituteId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/rooms/?instituteId=$instituteId'));
      
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Room.fromJSON(json)).toList();
      } else {
        throw Exception('Failed to load rooms');
      }
    } catch (e) {
      throw Exception('Error fetching rooms: $e');
    }
  }
}
