import 'package:mobile_iot/iam/domain/repositories/auth_repository.dart';
import 'package:mobile_iot/iam/domain/entities/credentials.dart';

/// Use case for handling user authentication business logic.
/// 
/// This use case encapsulates the application-specific logic for user sign-in
/// operations.
/// 
class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  /// Executes the sign-in operation with the provided credentials.
  /// 
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