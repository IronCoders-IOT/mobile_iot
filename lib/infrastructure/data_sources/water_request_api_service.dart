import 'package:http/http.dart' as http;
import 'dart:convert';
class WaterRequestApiService {
  static const String _baseUrl = 'http://192.168.18.4:8080/api/v1/water-request';
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
    return null;
  }
}