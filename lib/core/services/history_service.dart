import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/history.dart';

class HistoryService {
  final String baseUrl = dotenv.env['API_URL'].toString();

  Future<List<History>> fetchHistoricalData(
    int roomId,
    String parameter,
    bool aqiIncluded,
    DateTime start,
    DateTime end,
    int precision,
  ) async {
    try {
      final String startDate = start.toIso8601String();
      final String endDate = end.toIso8601String();

      final response = await http.get(Uri.parse(
        '$baseUrl/history/?roomId=$roomId&parameter=$parameter&aqiIncluded=$aqiIncluded&start=$startDate&end=$endDate&precision=$precision',
      ));

      final jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (jsonData is List && jsonData.isNotEmpty) {
          final historyList = jsonData.map((item) {
            return History.fromJson(item);
          }).toList()..sort((a, b) => a.bucketStart.compareTo(b.bucketStart));
          return historyList;
        } else if (jsonData.isEmpty) {
          return List.empty();
        } else {
          throw Exception('Unexpected JSON format: ${jsonData.runtimeType}');
        }
      } else {
        throw Exception('Failed to load history: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching history: $e');
    }
  }
}
