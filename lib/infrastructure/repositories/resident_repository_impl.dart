import 'package:mobile_iot/infrastructure/data_sources/resident_api_service.dart';
import 'package:mobile_iot/domain/repositories/resident_repository.dart';

class ResidentRepositoryImpl implements ResidentRepository {
  final ResidentApiService residentApiService;

  ResidentRepositoryImpl(this.residentApiService);

  @override
  Future<Map<String, dynamic>?> getResident(String token) {
    return residentApiService.getResident(token);
  }

}