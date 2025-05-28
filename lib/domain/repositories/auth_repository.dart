import '../value_objects/credentials.dart';

abstract class AuthRepository {
  Future<String?> signIn(Credentials credentials);
}