import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_iot/core/config/env.dart';
import 'package:mobile_iot/analytics/domain/entities/report.dart';
import 'package:mobile_iot/shared/exceptions/session_expired_exception.dart';
import 'package:mobile_iot/profiles/domain/entities/resident.dart';

/// Service for handling resident-related API requests.
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
        Uri.parse('$_baseUrl/{residentId}/profiles'),
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

  /// Retrieves all reports associated with a specific resident from the API.
  /// 
  /// This method makes an HTTP GET request to the backend API to fetch
  /// all reports that were created by the specified resident using the new
  /// endpoint structure: /api/v1/residents/{residentId}/issue-reports
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [residentId]: The unique identifier of the resident
  /// 
  /// Returns a Future that completes with a list of Report entities.
  ///
  /// Throws:
  /// - [SessionExpiredException] when the authentication token is invalid (401/403)
  /// - [Exception] for other network or data access errors
  Future<List<Report>> getReportByResidentId(String token, int residentId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$residentId/issue-reports'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Report.fromJson(json)).toList();
    } else {
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw SessionExpiredException();
      }
      throw Exception('Failed to load reports: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }


}