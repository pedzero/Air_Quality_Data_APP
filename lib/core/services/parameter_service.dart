import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/parameter.dart';

class ParameterService {
  final String baseUrl = dotenv.env['API_URL'].toString();

  Future<List<Parameter>> fetchParametersName(int roomId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/parameters/?roomId=$roomId'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Parameter.fromJSON(json)).toList();
      } else {
        throw Exception('Failed to load parameters name');
      }
    } catch (e) {
      throw Exception('Error fetching parameters name: $e');
    }
  }

  Future<List<Parameter>> fetchParameter(int roomId, String name,
      [int limit = 1]) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/parameters/?roomId=$roomId&name=$name&limit=$limit'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData
            .map((json) => Parameter.fromJSON(json))
            .toSet()
            .toList();
      } else {
        throw Exception('Failed to load parameters');
      }
    } catch (e) {
      throw Exception('Error fetching parameters: $e');
    }
  }

  static Future<double> fetchParameterValue(int roomId, String name) async {
    try {
      final String baseUrl = dotenv.env['API_URL'].toString();
      final response = await http.get(
          Uri.parse('$baseUrl/parameters/?roomId=$roomId&name=$name&limit=1'));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        final value = (jsonData.first['value'] as num?)?.toDouble() ?? 0.0;
        return value;
      } else {
        throw Exception('Failed to load parameters');
      }
    } catch (e) {
      throw Exception('Error fetching parameters: $e');
    }
  }
}
