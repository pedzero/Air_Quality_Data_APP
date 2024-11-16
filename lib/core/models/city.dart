class City {
  final String name;
  final int id;

  City({
    required this.name,
    required this.id
  });
  
  factory City.fromJSON(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      id: json['id']
    );
  }
}