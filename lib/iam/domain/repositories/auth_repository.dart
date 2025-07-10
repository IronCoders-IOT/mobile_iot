import '../entities/credentials.dart';

/// Abstract interface for authentication operations
/// 
/// This repository defines the contract for all authentication-related operations
/// that the application needs to perform.
///
abstract class AuthRepository {
  /// Authenticates a user with the provided credentials.
  /// 
  /// This method attempts to authenticate a user using their username and password.
  /// If authentication is successful, it returns an authentication token that
  /// can be used for subsequent API requests. If authentication fails, it
  /// returns null.
  /// 
  /// [credentials] - The user's authentication credentials (username and password)
  /// 
  Future<String?> signIn(Credentials credentials);
}