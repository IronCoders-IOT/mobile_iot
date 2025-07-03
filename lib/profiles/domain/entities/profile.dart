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