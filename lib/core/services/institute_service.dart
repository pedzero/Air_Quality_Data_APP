import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/institute.dart';

class InstituteService {
  final String baseUrl = dotenv.env['API_URL'].toString();

  Future<Institute?> fetchInstituteById(int instituteId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/institutes/?id=$instituteId'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData.isNotEmpty) {
          return Institute.fromJSON(jsonData);
        } else {
          return null;
        }
      } else {
        throw Exception('Failed to load institute');
      }
    } catch (e) {
      throw Exception('Error fetching institute: $e');
    }
  }

  Future<List<Institute>> fetchInstitutes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/institutes'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Institute.fromJSON(json)).toList();
      } else {
        throw Exception('Failed to load institutes');
      }
    } catch (e) {
      throw Exception('Error fetching institutes: $e');
    }
  }

  Future<List<Institute>> fetchInstitutesByCityId(int cityId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/institutes/?cityId=$cityId'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Institute.fromJSON(json)).toList();
      } else {
        throw Exception('Failed to load institutes');
      }
    } catch (e) {
      throw Exception('Error fetching institutes: $e');
    }
  }
}
