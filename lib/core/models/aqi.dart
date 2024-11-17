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
    return AQI(
      index: json['overall']['index'] ?? 0,
      category: json['overall']['category'] ?? 'Unknown',
      parameters: (json['parameters'] as List<dynamic>?)
              ?.map((paramJson) => Parameter.fromJSON({
                    'name': paramJson['parameter'],
                    'id': 0, 
                    'room_id': 0, 
                    'value': paramJson['value'],
                    'aqi_included': true,
                    'timestamp': paramJson['timestamp'],
                  }))
              .toList() ??
          [],
    );
  }
}
