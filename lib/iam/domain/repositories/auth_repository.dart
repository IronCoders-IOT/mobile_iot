import '../entities/credentials.dart';

/// Abstract interface for authentication operations in the domain layer.
/// 
/// This repository defines the contract for all authentication-related operations
/// that the application needs to perform. It follows the dependency inversion
/// principle by allowing the domain layer to define what authentication
/// operations are needed without depending on specific implementations.
/// 
/// The AuthRepository is responsible for:
/// - User authentication (sign in)
/// - Token management
/// - Session handling
/// - Authentication state management
/// 
/// Implementations of this interface handle the actual communication with
/// authentication services, whether they be remote APIs, local storage,
/// or other authentication providers.
abstract class AuthRepository {
  /// Authenticates a user with the provided credentials.
  /// 
  /// This method attempts to authenticate a user using their username and password.
  /// If authentication is successful, it returns an authentication token that
  /// can be used for subsequent API requests. If authentication fails, it
  /// returns null.
  /// 
  /// The method handles:
  /// - Credential validation
  /// - Communication with authentication service
  /// - Token extraction from response
  /// - Error handling for authentication failures
  /// 
  /// [credentials] - The user's authentication credentials (username and password)
  /// 
  /// Returns a Future that completes with:
  /// - String token if authentication is successful
  /// - null if authentication fails (invalid credentials, network error, etc.)
  /// 
  /// Throws:
  /// - NetworkException: When there are connectivity issues
  /// - ServerException: When the authentication service is unavailable
  /// - ValidationException: When credentials format is invalid
  Future<String?> signIn(Credentials credentials);
}