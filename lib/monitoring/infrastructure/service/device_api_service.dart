import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_iot/monitoring/domain/entities/device.dart';
import 'package:mobile_iot/core/config/env.dart';
import 'package:mobile_iot/shared/exceptions/session_expired_exception.dart';

/// Service class for handling device-related API operations.
/// 
/// This class provides methods for communicating with the backend API
/// to retrieve device information. It handles HTTP requests, response
/// parsing, and error management for device data operations.
/// 
/// The service uses the http package for network communication and
/// includes proper error handling for authentication and network issues.
class DeviceApiService {
  static final String _baseUrl = '${Env.apiUrl}${Env.sensorsEndpoint}';

  /// Retrieves devices associated with a specific resident from the API.
  /// 
  /// This method makes an HTTP GET request to the backend API to fetch
  /// all devices that belong to or are managed by the specified resident.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [id]: The unique identifier of the resident
  /// 
  /// Returns a Future that completes with a list of Device entities.
  /// 
  /// Throws:
  /// - [SessionExpiredException] when the authentication token is invalid (401/403)
  /// - [Exception] for other network or data access errors
  Future<List<Device>> getDevice(String token, int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/resident/$id/all'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Device.fromJson(json)).toList();
    } else {
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw SessionExpiredException();
      }
      throw Exception('Failed to load devices: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}