import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/credentials.dart';
import 'package:mobile_iot/core/config/env.dart';

/// Service responsible for HTTP communication with the authentication API.
/// 
/// This service handles all direct HTTP requests to the authentication server,
/// including user sign-in operations.
/// 
class AuthApiService {

  static final String baseUrl = '${Env.apiUrl}${Env.authenticationEndpoint}';

  /// Authenticates a user by sending credentials to the authentication server.
  /// 
  /// This method performs an HTTP POST request to the sign-in endpoint with
  /// the user's credentials.
  ///
  /// [credentials] - The user's authentication credentials (username and password)
  /// 
  /// Throws:
  /// - SocketException: When there are network connectivity issues
  /// - HttpException: When there are HTTP-related errors
  /// - FormatException: When the response cannot be parsed as JSON
  Future<String?> signIn(Credentials credentials) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(credentials.toJson()),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['token'];
    }
    return null;
  }
}