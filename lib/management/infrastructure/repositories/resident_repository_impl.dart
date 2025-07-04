import 'package:mobile_iot/management/domain/interfaces/resident_repository.dart';
import 'package:mobile_iot/management/domain/entities/resident.dart';
import 'package:mobile_iot/management/infrastructure/data_sources/resident_api_service.dart';

class ResidentRepositoryImpl implements ResidentRepository {
  final ResidentApiService residentApiService;

  ResidentRepositoryImpl(this.residentApiService);

  @override
  Future<Map<String, dynamic>?> getResident(String token) {
    return residentApiService.getResident(token);
  }

}