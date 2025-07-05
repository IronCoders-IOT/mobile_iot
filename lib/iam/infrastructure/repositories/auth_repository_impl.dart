import 'package:mobile_iot/iam/domain/repositories/auth_repository.dart';
import 'package:mobile_iot/iam/domain/entities/user.dart';
import 'package:mobile_iot/iam/domain/entities/credentials.dart';
import 'package:mobile_iot/iam/infrastructure/service/auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService apiService;

  AuthRepositoryImpl(this.apiService);

  @override
  Future<String?> signIn(Credentials credentials) {
    return apiService.signIn(credentials);
  }
}