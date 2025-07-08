import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_iot/core/config/env.dart';

/// Service for handling resident-related API requests.
///
/// This class provides a method to interact with the backend API for resident profile retrieval.
/// It handles HTTP requests and response parsing, as well as error handling for resident endpoints.
class ResidentApiService {
  static final String _baseUrl = '${Env.apiUrl}${Env.residentsEndpoint}';

  /// Retrieves the resident profile information for the user via a GET request.
  ///
  /// Parameters:
  /// - [token]: The authentication token for the user
  ///
  /// Returns a [Future] that completes with a [Map<String, dynamic>] containing the resident data if successful, or throws an exception on error.
  Future<Map<String, dynamic>?> getResident(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json;
      } else if (response.statusCode == 401) {
        throw Exception('Sesión expirada. Por favor, inicie sesión nuevamente.');
      } else if (response.statusCode == 404) {
        throw Exception('Resident no encontrado');
      } else {
        throw Exception('Error al cargar el resident: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }
}