class Credentials {
  final String username;
  final String password;

  Credentials({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}