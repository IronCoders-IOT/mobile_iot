import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Guardar token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // Obtener token
  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Eliminar token
  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }

  // Verificar si existe token
  Future<bool> hasToken() async {
    return await _storage.read(key: 'jwt_token') != null;
  }
} 