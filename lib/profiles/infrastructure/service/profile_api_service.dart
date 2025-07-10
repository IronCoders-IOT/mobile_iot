import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_iot/core/config/env.dart';

/// Service for handling profile-related API requests.
class ProfileApiService {
  static final String _baseUrl = '${Env.apiUrl}${Env.profileEndpoint}';

  /// Updates the profile information for the user via a PUT request.
  ///
  /// Parameters:
  /// - [token]: The authentication token for the user
  /// - [firstName]: The user's first name
  /// - [lastName]: The user's last name
  /// - [email]: The user's email address
  /// - [direction]: The user's address or direction
  /// - [documentNumber]: The user's document number
  /// - [documentType]: The type of document
  /// - [phone]: The user's phone number
  ///
  /// Returns a [Future] that completes with a new token if successful, or null otherwise.
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


  /// Retrieves the profile information for the user via a GET request.
  ///
  /// Parameters:
  /// - [token]: The authentication token for the user
  ///
  /// Returns a [Future] that completes with a [Map<String, dynamic>] containing the profile data if successful, or throws an exception on error.
  Future<Map<String, dynamic>?> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/{id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json;
      } else if (response.statusCode == 401) {
        throw Exception('Session expired');
      } else if (response.statusCode == 404) {
        throw Exception('Profile not found');
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Connection error: $e');
    }
  }
}

