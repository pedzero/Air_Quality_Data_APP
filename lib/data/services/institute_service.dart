import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/institute.dart';

class InstituteService {
  final String baseUrl = dotenv.env['API_URL'].toString();

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

  Future<List<Institute>> fetchInstitutesByCityName(String cityName) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/institutes/?city=$cityName'));
      
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
