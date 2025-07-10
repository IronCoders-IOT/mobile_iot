/// Represents user authentication credentials for login operations.
/// 
/// This entity encapsulates the sensitive authentication data required to
/// authenticate a user with the system.
/// 
///
class Credentials {
  final String username;
  final String password;
  Credentials({required this.username, required this.password});

  /// Converts the Credentials instance to a JSON object for API requests.
  /// 
  /// This method is used when sending authentication data to the server.
  /// The resulting JSON object contains the username and password fields
  /// that the authentication API expects.
  /// 
  /// Returns a Map containing the credentials for API transmission
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}