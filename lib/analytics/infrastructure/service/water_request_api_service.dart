import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_iot/analytics/domain/entities/water_request.dart';
import 'package:mobile_iot/core/config/env.dart';
import 'package:mobile_iot/shared/exceptions/session_expired_exception.dart';

/// Service class for handling water request-related API operations.
/// 
/// This class provides methods for communicating with the backend API
/// to create and retrieve water request data. It handles HTTP requests, response
/// parsing, and error management for water request data operations.
/// 
/// The service uses the http package for network communication and
/// includes proper error handling for authentication and network issues.
class WaterRequestApiService {

  static final String _baseUrl = '${Env.apiUrl}${Env.waterRequestsEndpoint}';

  /// Creates a new water supply request in the backend system via API.
  /// 
  /// This method makes an HTTP POST request to the backend API to submit
  /// a new water request with the specified details. The request is created
  /// with the provided amount, status, and delivery information.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [requestedLiters]: The amount of water requested in liters
  /// - [status]: The initial status of the request (typically 'received')
  /// - [deliveredAt]: The expected or actual delivery date/time
  /// 
  /// Returns a Future that completes with a success token or null.
  /// 
  /// Throws:
  /// - [SessionExpiredException] when the authentication token is invalid (401/403)
  Future<String?> createWaterRequest(String token,
      String requestedLiters, String status, String deliveredAt) async{
    final response =await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'requestedLiters': requestedLiters,
        'status': status,
        'deliveredAt': deliveredAt,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return json['token'];
    }
    if (response.statusCode == 401 || response.statusCode == 403) {
      throw SessionExpiredException();
    }
    return null;
  }

  /// Retrieves all water requests associated with a specific resident from the API.
  /// 
  /// This method makes an HTTP GET request to the backend API to fetch
  /// all water supply requests that were created by the specified resident.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [id]: The unique identifier of the resident
  /// 
  /// Returns a Future that completes with a list of WaterRequest entities.
  /// 
  /// Throws:
  /// - [SessionExpiredException] when the authentication token is invalid (401/403)
  /// - [Exception] for other network or data access errors
  Future<List<WaterRequest>> getAllRequestsByResidentId(String token, int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/resident/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => WaterRequest.fromJson(json)).toList();
    } else {
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw SessionExpiredException();
      }
      throw Exception('Failed to load analytics requests');
    }
  }
}