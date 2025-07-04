import 'package:mobile_iot/iam/domain/interfaces/auth_repository.dart';
import 'package:mobile_iot/iam/domain/entities/credentials.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<String?> execute(Credentials credentials) {
    return repository.signIn(credentials);
  }
}