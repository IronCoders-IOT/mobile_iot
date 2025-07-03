import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_iot/domain/entities/report.dart';

class ReportApiService {
  static const String _baseUrl = 'https://aquaconecta-gch4brewcpb5ewhc.centralus-01.azurewebsites.net/api/v1/requests';
  //static const String _baseUrl = 'http://192.168.18.4:8080/api/v1/requests';

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
      throw Exception('Failed to load reports');
    }
  }


}