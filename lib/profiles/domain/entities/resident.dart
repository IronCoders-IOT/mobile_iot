class Resident{
  final int id;
  final String? username;

  Resident({required this.id, this.username});

  /// Creates a [Resident] entity from a JSON map.
  ///
  /// Parameters:
  /// - [json]: The JSON map containing resident data
  ///
  /// Returns a [Resident] instance populated with the data from the JSON map.
  factory Resident.fromJson(Map<String, dynamic> json) {
    return Resident(
      id: json['id'] as int,
      username: json['username'] as String?,
    );
  }
}