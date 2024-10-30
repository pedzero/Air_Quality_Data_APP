class Institute {
  final String name;
  final int id;
  final int cityId;

  Institute({
    required this.name,
    required this.id,
    required this.cityId
  });
  
  factory Institute.fromJSON(Map<String, dynamic> json) {
    return Institute(
      name: json['name'],
      id: json['id'],
      cityId: json['city_id']
    );
  }
}