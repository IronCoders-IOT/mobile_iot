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
/// The AuthRepositoryImpl is responsible for:
/// - Implementing the AuthRepository contract
/// - Coordinating with the API service for authentication
/// - Handling data transformation between domain and infrastructure layers
/// - Managing authentication state and token storage
/// 
/// This implementation follows the Clean Architecture principle of keeping
/// infrastructure concerns separate from domain logic.
class AuthRepositoryImpl implements AuthRepository {
  /// The API service that handles HTTP communication with the authentication server.
  /// 
  /// This dependency is injected through the constructor, allowing for easy
  /// testing and flexibility in how authentication requests are handled.
  final AuthApiService apiService;

  /// Creates a new AuthRepositoryImpl instance with the required API service dependency.
  /// 
  /// [apiService] - The API service that will handle HTTP communication with
  ///                the authentication server
  AuthRepositoryImpl(this.apiService);

  /// Implements the sign-in operation by delegating to the API service.
  /// 
  /// This method takes the user credentials and forwards them to the API service
  /// for authentication. The API service handles the actual HTTP communication
  /// with the authentication server and returns the authentication token.
  /// 
  /// The implementation maintains a clean separation between the repository
  /// logic and the HTTP communication details, making it easy to test and
  /// potentially swap out different authentication providers.
  /// 
  /// [credentials] - The user's authentication credentials (username and password)
  /// 
  /// Returns a Future that completes with:
  /// - String token if authentication is successful
  /// - null if authentication fails
  /// 
  /// Throws any exceptions that occur during the API communication
  @override
  Future<String?> signIn(Credentials credentials) {
    return apiService.signIn(credentials);
  }
}