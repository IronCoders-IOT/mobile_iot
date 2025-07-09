/// Entity representing a resident.
///
/// This class encapsulates the minimal information for a resident, currently only the unique ID.
/// It provides deserialization from JSON data.
class Resident{
  final int id;

  Resident({required this.id});

  /// Creates a [Resident] entity from a JSON map.
  ///
  /// Parameters:
  /// - [json]: The JSON map containing resident data
  ///
  /// Returns a [Resident] instance populated with the data from the JSON map.
  factory Resident.fromJson(Map<String, dynamic> json) {
    return Resident(
      id: json['id'] as int,
    );
  }
}