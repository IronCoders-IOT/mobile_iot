import 'package:mobile_iot/profiles/domain/repositories/resident_repository.dart';
import 'package:mobile_iot/profiles/domain/entities/resident.dart';

/// Use case for handling resident-related business logic.
class ResidentUseCase{
  final ResidentRepository residentRepository;

  ResidentUseCase(this.residentRepository);

  /// Retrieves the resident profile information for the user.
  ///
  /// Parameters:
  /// - [token]: The authentication token for the user
  ///
  /// Returns a [Future] that completes with the [Resident] entity if found, or null if not found.
  Future<Resident?> getProfile(String token) {
    return residentRepository.getResident(token).then((data) {
      if (data == null) return null;
      return Resident.fromJson(data);
    });
  }

}