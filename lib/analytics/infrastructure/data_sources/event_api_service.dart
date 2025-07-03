import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_iot/analytics/domain/entities/event.dart';

class EventApiService {
  static const String _baseUrl = 'https://aquaconecta-gch4brewcpb5ewhc.centralus-01.azurewebsites.net/api/v1/events';
  //static const String _baseUrl = 'http://192.168.18.4:8080/api/v1/events';

  Future<List<Event>> getAllEventsBySensorId(String token, int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/sensor/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}