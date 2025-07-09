import 'package:mobile_iot/iam/domain/repositories/auth_repository.dart';
import 'package:mobile_iot/iam/domain/entities/user.dart';
import 'package:mobile_iot/iam/domain/entities/credentials.dart';
import 'package:mobile_iot/iam/infrastructure/service/auth_api_service.dart';

/// Concrete implementation of the AuthRepository interface.
/// 
/// This class provides the actual implementation of authentication operations
/// by delegating to the AuthApiService for HTTP communication with the
/// authentication server. It acts as an adapter between the domain layer
/// and the infrastructure layer.
/// 
/// This implementation follows the Clean Architecture principle of keeping
/// infrastructure concerns separate from domain logic.
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService apiService;

  AuthRepositoryImpl(this.apiService);

  /// Implements the sign-in operation by delegating to the API service.
  /// 
  /// This method takes the user credentials and forwards them to the API service
  /// for authentication. The API service handles the actual HTTP communication
  /// with the authentication server and returns the authentication token.
  /// 
  /// [credentials] - The user's authentication credentials (username and password)
  /// 
  /// Returns a Future that completes with:
  /// - String token if authentication is successful
  /// - null if authentication fails
  @override
  Future<String?> signIn(Credentials credentials) {
    return apiService.signIn(credentials);
  }
}