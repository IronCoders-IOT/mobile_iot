import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_iot/core/config/env.dart';

class ProfileApiService {
  static final String _baseUrl = '${Env.apiUrl}${Env.profileEndpoint}';

  Future<String?> updateProfile(
      String token,
      String firstName,
      String lastName,
      String email,
      String direction,
      String documentNumber,
      String documentType,
      String phone ) async{
    final response =await http.put(
      Uri.parse('$_baseUrl/me/edit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'direction': direction,
        'documentNumber': documentNumber,
        'documentType': documentType,
        'phone': phone
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return json['token'];
    }
    return null;
  }
  Future<String?>createProfile(String token,
      String firstName,
      String lastName,
      String email,
      String direction,
      String documentNumber,
      String documentType,
      String phone ) async{
    final response =await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'direction': direction,
        'documentNumber': documentNumber,
        'documentType': documentType,
        'phone': phone
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return json['token'];
    }
    return null;
  }
  Future<Map<String, dynamic>?> getProfile(String token) async {
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
        throw Exception('Perfil no encontrado');
      } else {
        throw Exception('Error al cargar el perfil: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }
}

