class History {
  final DateTime bucketStart;
  final double averageValue;
  final double maxValue;
  final double minValue;

  History({
    required this.bucketStart,
    required this.averageValue,
    required this.maxValue,
    required this.minValue,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    try {
      return History(
        bucketStart: DateTime.parse(json['bucket_start']),
        averageValue: (json['average_value'] as num?)?.toDouble() ?? 0.0,
        maxValue: (json['max_value'] as num?)?.toDouble() ?? 0.0,
        minValue: (json['min_value'] as num?)?.toDouble() ?? 0.0,
      );
    } catch (e) {
      throw Exception("Error parsing History: $e");
    }
  }
}
