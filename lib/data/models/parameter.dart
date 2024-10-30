class Parameter {
  final String name;
  final int id;
  final int roomId;
  final double value;
  final bool aqiIncluded;
  final DateTime timestamp;

  Parameter({
    required this.name,
    required this.id,
    required this.roomId,
    required this.value,
    required this.aqiIncluded,
    required this.timestamp
  });
  
  factory Parameter.fromJSON(Map<String, dynamic> json) {
    return Parameter(
      name: json['name'] as String,
      id: json['id'] as int,
      roomId: json['room_id'] as int,
      value: (json['value'] as num).toDouble(),
      aqiIncluded: json['aqi_included'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String)
    );
  }
}