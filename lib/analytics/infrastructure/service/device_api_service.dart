import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_iot/analytics/domain/entities/device.dart';
import 'package:mobile_iot/core/config/env.dart';
import 'package:mobile_iot/shared/exceptions/session_expired_exception.dart';

class DeviceApiService {
  static final String _baseUrl = '${Env.apiUrl}${Env.sensorsEndpoint}';

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