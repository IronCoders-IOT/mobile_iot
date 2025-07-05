import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/credentials.dart';
import 'package:mobile_iot/core/config/env.dart';
class AuthApiService {
  static final String baseUrl = '${Env.apiUrl}${Env.authentication}';

  Future<String?> signIn(Credentials credentials) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(credentials.toJson()),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['token'];
    }
    return null;
  }
}