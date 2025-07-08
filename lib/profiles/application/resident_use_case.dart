import 'package:mobile_iot/profiles/domain/interfaces/resident_repository.dart';
import 'package:mobile_iot/profiles/domain/entities/resident.dart';

/// Use case for handling resident-related business logic.
///
/// This class acts as an intermediary between the presentation layer and the domain layer,
/// encapsulating the application-specific logic for resident profile retrieval. It ensures
/// that resident management follows the application's business rules and requirements.
class ResidentUseCase{
  /// The resident repository that handles the actual resident operations.
  ///
  /// This dependency is injected through the constructor, following the
  /// dependency inversion principle. The use case depends on the abstract
  /// ResidentRepository interface rather than concrete implementations.
  final ResidentRepository residentRepository;

  /// Creates a new ResidentUseCase instance with the required repository dependency.
  ///
  /// [residentRepository] - The resident repository that will handle the actual resident operations
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