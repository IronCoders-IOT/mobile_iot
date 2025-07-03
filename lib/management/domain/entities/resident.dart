class Resident{
  final int id;

  Resident({required this.id});

  factory Resident.fromJson(Map<String, dynamic> json) {
    return Resident(
      id: json['id'] as int,
    );
  }
}