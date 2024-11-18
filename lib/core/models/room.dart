//import 'package:air_quality_data_app/core/models/AQI.dart';
import 'package:air_quality_data_app/core/models/parameter.dart';

class Room {
  final String name;
  final int id;
  final int instituteId;
  final String instituteName;
  final int cityId;
  final String cityName;
  //final AQI aqi;
  final List<Parameter> parameters;

  Room({
    required this.name,
    required this.id,
    required this.instituteId,
    required this.instituteName,
    required this.cityId,
    required this.cityName,
    //required this.aqi,
    required this.parameters,
  });

  factory Room.fromJSON(Map<String, dynamic> json) {
    return Room(
      name: json['name'] ?? '',
      id: json['id'] ?? 0,
      instituteId: json['institute_id'] ?? 0,
      instituteName: json['institute_name'] ?? '',
      cityId: json['city_id'] ?? 0,
      cityName: json['city_name'] ?? '',
      //aqi: AQI.fromJSON(json['aqi'] ?? {}), 
      parameters: (json['parameters'] as List<dynamic>?)
              ?.map((param) => Parameter.fromJSON(param))
              .toList() ??
          [], 
    );
  }
}
