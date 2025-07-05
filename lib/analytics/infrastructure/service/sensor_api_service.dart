import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_iot/analytics/domain/entities/sensor.dart';
import 'package:mobile_iot/core/config/env.dart';
import 'package:mobile_iot/shared/exceptions/session_expired_exception.dart';

class SensorApiService {
  static final String _baseUrl = '${Env.apiUrl}${Env.sensorsEndpoint}';

  Future<List<Sensor>> getSensor(String token, int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/resident/$id/all'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Sensor.fromJson(json)).toList();
    } else {
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw SessionExpiredException();
      }
      throw Exception('Failed to load sensors: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}