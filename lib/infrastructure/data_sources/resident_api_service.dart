import 'package:http/http.dart' as http;
import 'dart:convert';
class ResidentApiService {
  static const String _baseUrl = 'http://192.168.18.4:8080/api/v1/residents';
  Future<Map<String, dynamic>?> getResident(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json;
      } else if (response.statusCode == 401) {
        throw Exception('Sesión expirada. Por favor, inicie sesión nuevamente.');
      } else if (response.statusCode == 404) {
        throw Exception('Resident no encontrado');
      } else {
        throw Exception('Error al cargar el resident: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }
}