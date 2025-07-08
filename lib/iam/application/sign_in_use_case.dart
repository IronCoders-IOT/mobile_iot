import 'package:mobile_iot/iam/domain/repositories/auth_repository.dart';
import 'package:mobile_iot/iam/domain/entities/credentials.dart';

/// Use case for handling user authentication business logic.
/// 
/// This use case encapsulates the application-specific logic for user sign-in
/// operations. It acts as an intermediary between the presentation layer and
/// the domain layer, ensuring that authentication follows the application's
/// business rules and requirements.
/// 
/// The SignInUseCase is responsible for:
/// - Coordinating authentication operations
/// - Applying business rules to authentication
/// - Managing the authentication flow
/// - Providing a clean interface for the presentation layer
/// 
/// This use case follows the Clean Architecture principle of keeping business
/// logic separate from infrastructure concerns and presentation logic.
class SignInUseCase {
  /// The authentication repository that handles the actual authentication operations.
  /// 
  /// This dependency is injected through the constructor, following the
  /// dependency inversion principle. The use case depends on the abstract
  /// AuthRepository interface rather than concrete implementations.
  final AuthRepository repository;

  /// Creates a new SignInUseCase instance with the required repository dependency.
  /// 
  /// [repository] - The authentication repository that will handle the actual
  ///                authentication operations
  SignInUseCase(this.repository);

  /// Executes the sign-in operation with the provided credentials.
  /// 
  /// This method orchestrates the authentication process by:
  /// - Delegating the authentication to the repository
  /// - Handling any business logic specific to the application
  /// - Returning the authentication result
  /// 
  /// The method maintains a clean separation between business logic and
  /// infrastructure concerns, making it easy to test and maintain.
  /// 
  /// [credentials] - The user's authentication credentials (username and password)
  /// 
  /// Returns a Future that completes with:
  /// - String token if authentication is successful
  /// - null if authentication fails
  /// 
  /// Throws any exceptions that occur during the authentication process
  Future<String?> execute(Credentials credentials) {
    return repository.signIn(credentials);
  }
}