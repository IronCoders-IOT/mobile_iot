import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_iot/analytics/domain/entities/water_request.dart';
import 'package:mobile_iot/core/config/env.dart';
import 'package:mobile_iot/shared/exceptions/session_expired_exception.dart';

class WaterRequestApiService {
  static final String _baseUrl = '${Env.apiUrl}${Env.waterRequestsEndpoint}';

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