import '../entities/credentials.dart';

abstract class AuthRepository {
  Future<String?> signIn(Credentials credentials);
}