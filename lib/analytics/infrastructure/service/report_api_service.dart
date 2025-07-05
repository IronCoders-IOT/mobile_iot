import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_iot/analytics/domain/entities/report.dart';
import 'package:mobile_iot/core/config/env.dart';
import 'package:mobile_iot/shared/exceptions/session_expired_exception.dart';

class ReportApiService {
  static final String _baseUrl = '${Env.apiUrl}${Env.requestsEndpoint}';

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