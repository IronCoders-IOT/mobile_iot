import 'package:mobile_iot/profiles/domain/interfaces/profile_repository.dart';
import 'package:mobile_iot/profiles/domain/entities/profile.dart';
import 'package:mobile_iot/profiles/infrastructure/data_sources/profile_api_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApiService apiService;
  ProfileRepositoryImpl(this.apiService);
  @override
  Future<Map<String, dynamic>?> getProfile(String token) {
    return apiService.getProfile(token);
  }
  @override
  Future<void> updateProfile(
      String token,
      String firstName,
      String lastName,
      String email,
      String direction,
      String documentNumber,
      String documentType,
      String phone) {
    return apiService.updateProfile(
        token, firstName, lastName, email, direction, documentNumber, documentType, phone);
  }
  @override
  Future<void> createProfile(
      String token,
      String firstName,
      String lastName,
      String email,
      String direction,
      String documentNumber,
      String documentType,
      String phone) {
    return apiService.createProfile(
        token, firstName, lastName, email, direction, documentNumber, documentType, phone);
  }
}