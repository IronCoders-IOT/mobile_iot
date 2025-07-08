/// Entity representing a user profile.
///
/// This class encapsulates all the personal and contact information for a user profile,
/// including names, email, address, document details, phone, and user ID. It provides
/// serialization and deserialization methods for working with JSON data.
class Profile{
  /// The user's first name.
  final String firstName;
  /// The user's last name.
  final String lastName;
  /// The user's email address.
  final String email;
  /// The user's address or direction.
  final String direction;
  /// The user's document number (e.g., ID or passport).
  final String documentNumber;
  /// The type of document (e.g., ID, passport).
  final String documentType;
  /// The user's phone number.
  final String phone;
  /// The unique user ID.
  final int userId;

  /// Creates a new [Profile] entity with the given user information.
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