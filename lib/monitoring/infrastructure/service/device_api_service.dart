import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_iot/monitoring/domain/entities/device.dart';
import 'package:mobile_iot/monitoring/domain/entities/event.dart';
import 'package:mobile_iot/core/config/env.dart';
import 'package:mobile_iot/shared/exceptions/session_expired_exception.dart';

/// Service class for handling device-related API operations.
/// 
/// This class provides methods for communicating with the backend API
/// to retrieve device information and events.
class DeviceApiService {
  static final String _baseUrl = '${Env.apiUrl}${Env.devicesEndpoint}';

  /// Retrieves events associated with a specific device from the API.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [deviceId]: The unique identifier of the device
  /// 
  /// Returns a Future that completes with a list of Event entities.
  /// 
  /// Throws:
  /// - [SessionExpiredException] when the authentication token is invalid (401/403)
  /// - [Exception] for other network or data access errors
  Future<List<Event>> getEventsByDeviceId(String token, int deviceId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$deviceId/events'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Event.fromJson(json)).toList();
    } else {
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw SessionExpiredException();
      }
      throw Exception('Failed to load events: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}