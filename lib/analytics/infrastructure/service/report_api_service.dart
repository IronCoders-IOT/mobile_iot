import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_iot/analytics/domain/entities/report.dart';
import 'package:mobile_iot/core/config/env.dart';
import 'package:mobile_iot/shared/exceptions/session_expired_exception.dart';

/// Service class for handling report-related API operations.
class ReportApiService {

  static final String _baseUrl = '${Env.apiUrl}${Env.issueReportsEndpoint}';

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
}