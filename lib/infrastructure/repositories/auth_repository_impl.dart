import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/value_objects/credentials.dart';
import '../data_sources/auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService apiService;

  AuthRepositoryImpl(this.apiService);

  @override
  Future<String?> signIn(Credentials credentials) {
    return apiService.signIn(credentials);
  }
}