class Room {
  final String name;
  final int id;
  final int instituteId;

  Room({
    required this.name,
    required this.id,
    required this.instituteId
  });
  
  factory Room.fromJSON(Map<String, dynamic> json) {
    return Room(
      name: json['name'],
      id: json['id'],
      instituteId: json['institute_id']
    );
  }
}