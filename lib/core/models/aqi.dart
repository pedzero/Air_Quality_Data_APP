import 'package:air_quality_data_app/core/models/parameter.dart';

class AQI {
  final int index;
  final String category;
  final List<Parameter> parameters;

  AQI({
    required this.index,
    required this.category,
    required this.parameters,
  });

  factory AQI.fromJSON(Map<String, dynamic> json) {
    final overall = json['overall'] as Map<String, dynamic>?;
    final parameters = json['parameters'] as List<dynamic>?;

    return AQI(
      index: overall?['index'] ?? 0,
      category: overall?['category'] ?? 'Unknown',
      parameters: parameters
              ?.map((paramJson) => Parameter.fromJSON({
                    'name': paramJson['parameter'] ?? 'Unknown',
                    'id': 0,
                    'room_id': 0,
                    'value': paramJson['value'] ?? 0,
                    'aqi_included': true,
                    'timestamp': paramJson['timestamp'] ?? '',
                  }))
              .toList() ??
          [],
    );
  }
}
