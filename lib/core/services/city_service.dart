import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/city.dart';

class CityService {
  final String baseUrl = dotenv.env['API_URL'].toString();

  Future<List<City>> fetchCities() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cities'));
      
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => City.fromJSON(json)).toList();
      } else {
        throw Exception('Failed to load cities');
      }
    } catch (e) {
      throw Exception('Error fetching cities: $e');
    }
  }

  Future<City?> fetchCityByName(String name) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cities?name=$name'));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData.isNotEmpty) {
          return City.fromJSON(jsonData);
        } else {
          return null;
        }
      } else {
        throw Exception('Failed to load city');
      }
    } catch (e) {
      throw Exception('Error fetching city: $e');
    }
  }
}
