class Profile{

  final String firstName;
  final String lastName;
  final String email;
  final String direction;
  final String documentNumber;
  final String documentType;
  final String phone;

  const Profile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.direction,
    required this.documentNumber,
    required this.documentType,
    required this.phone,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      direction: json['direction'] as String,
      documentNumber: json['documentNumber'] as String,
      documentType: json['documentType'] as String,
      phone: json['phone'] as String,
    );
  }

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