class Parameter {
  final String name;
  int id;
  int roomId;
  double value;
  final bool aqiIncluded;
  DateTime? timestamp;

  Parameter({
    required this.name,
    required this.id,
    required this.roomId,
    required this.value,
    required this.aqiIncluded,
    required this.timestamp,
  });

  factory Parameter.fromJSON(Map<String, dynamic> json) {
  return Parameter(
    name: json['name'] ?? 'Unknown',
    id: json['id'] ?? 0,
    roomId: json['room_id'] ?? 0,
    value: (json['value'] as num?)?.toDouble() ?? 0.0,
    aqiIncluded: json['aqi_included'] ?? false,
    timestamp: json['timestamp'] != null
        ? DateTime.parse(json['timestamp'] as String)
        : null,
  );
}

}
