import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_iot/analytics/domain/entities/report.dart';
import 'package:mobile_iot/core/config/env.dart';
import 'package:mobile_iot/shared/exceptions/session_expired_exception.dart';

/// Service class for handling report-related API operations.
/// 
/// This class provides methods for communicating with the backend API
/// to create and retrieve report data. It handles HTTP requests, response
/// parsing, and error management for report data operations.
/// 
/// The service uses the http package for network communication and
/// includes proper error handling for authentication and network issues.
class ReportApiService {
  /// The base URL for report-related API endpoints.
  /// 
  /// Constructed from the environment configuration to ensure
  /// consistency across different deployment environments.
  static final String _baseUrl = '${Env.apiUrl}${Env.requestsEndpoint}';

  /// Creates a new report in the backend system via API.
  /// 
  /// This method makes an HTTP POST request to the backend API to submit
  /// a new report with the specified details. The report is created with
  /// the provided title, description, and initial status.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [title]: The title of the report
  /// - [description]: The detailed description of the issue or observation
  /// - [status]: The initial status of the report (typically 'received')
  /// 
  /// Returns a Future that completes with a success token or null.
  /// 
  /// Throws:
  /// - [SessionExpiredException] when the authentication token is invalid (401/403)
  /// - [Exception] for other network or data access errors
  Future<String?>createReport(
      String token, String title, String description, String status) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
        'status': status,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return json['token'];
    } else {
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw SessionExpiredException();
      }
      throw Exception('Failed to create report: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

  /// Retrieves all reports associated with a specific resident from the API.
  /// 
  /// This method makes an HTTP GET request to the backend API to fetch
  /// all reports that were created by the specified resident.
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
      Uri.parse('$_baseUrl/resident/$residentId'),
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
      throw Exception('Failed to load reports');
    }
  }
}