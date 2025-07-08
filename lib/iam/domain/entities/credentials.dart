/// Represents user authentication credentials for login operations.
/// 
/// This entity encapsulates the sensitive authentication data required to
/// authenticate a user with the system. It contains the username and password
/// that will be sent to the authentication service.
/// 
/// The Credentials entity is used for:
/// - Login form data collection
/// - API authentication requests
/// - Secure credential handling during authentication flow
/// 
/// Note: This entity should be handled with care as it contains sensitive
/// information. Passwords should never be stored in plain text and should
/// be cleared from memory after use.
class Credentials {
  /// The username or email used for authentication.
  /// 
  /// This field identifies the user account that is attempting to authenticate.
  /// It can be either a username or email address depending on the system's
  /// authentication requirements.
  final String username;

  /// The password for the user account.
  /// 
  /// This field contains the secret password that validates the user's identity.
  /// The password should be handled securely and never logged or stored in
  /// plain text format.
  final String password;

  /// Creates a new Credentials instance with username and password.
  /// 
  /// [username] - The username or email for authentication
  /// [password] - The password for the user account
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