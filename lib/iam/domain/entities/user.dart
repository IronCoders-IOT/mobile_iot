/// This entity contains the core user data needed for identity and access management,
/// including username for identification and roles for authorization decisions.
class User {
  final String username;

  final List<String> roles;

  User({required this.username, required this.roles});

  /// Creates a User instance from a JSON object.
  /// 
  ///
  /// [json] - Map containing user data with 'username' and 'roles' keys
  /// 
  /// Returns a new User instance with data from the JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      roles: List<String>.from(json['roles']),
    );
  }

  /// Converts the User instance to a JSON object.
  /// 
  ///
  /// Returns a Map containing the user's username and roles
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'roles': roles,
    };
  }
}