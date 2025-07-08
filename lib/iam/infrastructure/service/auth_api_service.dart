import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/credentials.dart';
import 'package:mobile_iot/core/config/env.dart';

/// Service responsible for HTTP communication with the authentication API.
/// 
/// This service handles all direct HTTP requests to the authentication server,
/// including user sign-in operations. It encapsulates the low-level HTTP
/// communication details and provides a clean interface for authentication
/// operations.
/// 
/// The AuthApiService is responsible for:
/// - Making HTTP requests to the authentication endpoints
/// - Handling request/response serialization
/// - Managing HTTP headers and content types
/// - Processing authentication responses
/// - Error handling for network and server issues
/// 
/// This service follows the single responsibility principle by focusing
/// solely on HTTP communication with the authentication API.
class AuthApiService {
  /// The base URL for authentication API endpoints.
  /// 
  /// This URL is constructed from the environment configuration and
  /// provides the foundation for all authentication-related API calls.
  /// The URL combines the general API URL with the authentication-specific path.
  static final String baseUrl = '${Env.apiUrl}${Env.authentication}';

  /// Authenticates a user by sending credentials to the authentication server.
  /// 
  /// This method performs an HTTP POST request to the sign-in endpoint with
  /// the user's credentials. It handles the complete authentication flow
  /// including request preparation, HTTP communication, and response processing.
  /// 
  /// The method:
  /// - Serializes the credentials to JSON format
  /// - Sets appropriate HTTP headers for JSON communication
  /// - Sends a POST request to the sign-in endpoint
  /// - Processes the response to extract the authentication token
  /// - Returns null for failed authentication attempts
  /// 
  /// [credentials] - The user's authentication credentials (username and password)
  /// 
  /// Returns a Future that completes with:
  /// - String token if authentication is successful (HTTP 200)
  /// - null if authentication fails (any other HTTP status code)
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