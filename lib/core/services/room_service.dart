import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:air_quality_data_app/core/services/city_service.dart';
import 'package:air_quality_data_app/core/services/institute_service.dart';
import 'package:air_quality_data_app/core/services/parameter_service.dart';
import 'package:air_quality_data_app/core/services/aqi_service.dart';
import 'package:air_quality_data_app/core/models/aqi.dart';
import 'package:air_quality_data_app/core/models/parameter.dart';
import 'package:air_quality_data_app/core/models/room.dart';

class RoomService {
  final String baseUrl = dotenv.env['API_URL'].toString();

  final CityService _cityService = CityService();
  final InstituteService _instituteService = InstituteService();
  final ParameterService _parameterService = ParameterService();
  final AQIService _aqiService = AQIService();

  Future<Room?> fetchRoomById(int roomId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/rooms/?id=$roomId'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData.isNotEmpty) {
          return Room.fromJSON(jsonData);
        } else {
          return null;
        }
      } else {
        throw Exception('Failed to load room: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching room: $e');
    }
  }

  Future<List<Room>> fetchRooms() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/rooms'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Room.fromJSON(json)).toList();
      } else {
        throw Exception('Failed to load rooms: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching rooms: $e');
    }
  }

  Future<List<Room>> fetchRoomsByInstituteId(int instituteId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/rooms/?instituteId=$instituteId'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Room.fromJSON(json)).toList();
      } else {
        throw Exception('Failed to load rooms: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching rooms: $e');
    }
  }

  Future<Room> fetchCompleteRoom(int roomId) async {
    try {
      final room = await fetchRoomById(roomId);
      if (room == null) {
        throw Exception('Room not found with ID: $roomId');
      }

      final AQI aqi = await _aqiService.fetchAQI(roomId);

      final distinctParameters =
          await _parameterService.fetchParametersName(roomId);

      final parameters = <Parameter>[];
      for (var paramName in distinctParameters) {
        final param =
            await _parameterService.fetchParameter(roomId, paramName.name);
        parameters.add(param.first);
      }

      final institute =
          await _instituteService.fetchInstituteById(room.instituteId);
      if (institute == null) {
        throw Exception('Institute not found with ID: ${room.instituteId}');
      }

      final city = await _cityService.fetchCityById(institute.cityId);
      if (city == null) {
        throw Exception('City not found with ID: ${institute.cityId}');
      }

      return Room(
        name: room.name,
        id: room.id,
        instituteId: institute.id,
        instituteName: institute.name,
        cityId: city.id,
        cityName: city.name,
        aqi: aqi,
        parameters: parameters,
      );
    } catch (e) {
      throw Exception('Error fetching complete room: $e');
    }
  }
}
