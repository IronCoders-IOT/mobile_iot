/// Provides secure storage utilities for sensitive data in the application.
///
/// This file defines the [SecureStorageService] class, which handles storing,
/// retrieving, and deleting sensitive data such as authentication tokens using
/// secure device storage.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for securely storing and retrieving sensitive data.
///
/// Used for managing authentication tokens and other confidential information.
class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Save token to secure storage.
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  /// Retrieve token from secure storage.
  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  /// Delete token from secure storage.
  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }

  /// Check if a token exists in secure storage.
  Future<bool> hasToken() async {
    return await _storage.read(key: 'jwt_token') != null;
  }
} 