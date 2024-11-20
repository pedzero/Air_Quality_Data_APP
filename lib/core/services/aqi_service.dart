import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:air_quality_data_app/core/models/aqi.dart';

class AQIService {
  final String baseUrl = dotenv.env['API_URL'].toString();

  Future<AQI> fetchAQI(int roomId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/aqi/?roomId=$roomId'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData.isNotEmpty) {
          return AQI.fromJSON(jsonData);
        } else {
          return AQI.fromJSON({});
        }
      } else {
        throw Exception('Failed to load city');
      }
    } catch (e) {
      throw Exception('Error fetching city: $e');
    }
  }
}
