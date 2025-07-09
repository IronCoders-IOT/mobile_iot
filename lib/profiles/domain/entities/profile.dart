/// Entity representing a user profile.
///
/// This class encapsulates all the personal and contact information for a user profile,
/// including names, email, address, document details, phone, and user ID. It provides
/// serialization and deserialization methods for working with JSON data.
class Profile{
  final String firstName;
  final String lastName;
  final String email;
  final String direction;
  final String documentNumber;
  final String documentType;
  final String phone;
  final int userId;

  const Profile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.direction,
    required this.documentNumber,
    required this.documentType,
    required this.phone,
    required this.userId,
  });

  /// Creates a [Profile] entity from a JSON map.
  ///
  /// Parameters:
  /// - [json]: The JSON map containing profile data
  ///
  /// Returns a [Profile] instance populated with the data from the JSON map.
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      direction: json['direction'] as String,
      documentNumber: json['documentNumber'] as String,
      documentType: json['documentType'] as String,
      phone: json['phone'] as String,
      userId: json['userId'] as int,
    );
  }

  /// Converts the [Profile] entity to a JSON map.
  ///
  /// Returns a [Map<String, dynamic>] containing the profile data.
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'direction': direction,
      'documentNumber': documentNumber,
      'documentType': documentType,
      'phone': phone,
    };
  }
}