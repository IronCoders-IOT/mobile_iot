import 'package:mobile_iot/domain/repositories/resident_repository.dart';

import '../../domain/entities/resident.dart';

class ResidentUseCase{
  final ResidentRepository residentRepository;
  ResidentUseCase(this.residentRepository);

  Future<Resident?> getProfile(String token) {
    return residentRepository.getResident(token).then((data) {
      if (data == null) return null;
      return Resident.fromJson(data);
    });
  }

}