class User {
  final String username;
  final List<String> roles;

  User({required this.username, required this.roles});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      roles: List<String>.from(json['roles']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'roles': roles,
    };
  }
}