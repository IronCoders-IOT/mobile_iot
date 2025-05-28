import '../../domain/repositories/auth_repository.dart';
import '../../domain/value_objects/credentials.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<String?> execute(Credentials credentials) {
    return repository.signIn(credentials);
  }
}