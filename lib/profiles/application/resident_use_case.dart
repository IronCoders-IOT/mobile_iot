import 'package:mobile_iot/profiles/domain/repositories/resident_repository.dart';
import 'package:mobile_iot/profiles/domain/entities/resident.dart';

/// Use case for handling resident-related business logic.
///
/// This class acts as an intermediary between the presentation layer and the domain layer,
/// encapsulating the application-specific logic for resident profile retrieval. It ensures
/// that resident management follows the application's business rules and requirements.
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