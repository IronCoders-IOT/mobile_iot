import 'package:mobile_iot/profiles/domain/repositories/resident_repository.dart';
import 'package:mobile_iot/profiles/infrastructure/service/resident_api_service.dart';

/// Implementation of [ResidentRepository] for resident operations using a remote API service.
///
/// This class delegates resident data retrieval to the [ResidentApiService],
/// handling the communication with the backend API.
class ResidentRepositoryImpl implements ResidentRepository {
  /// The API service used for resident operations.
  final ResidentApiService residentApiService;

  /// Creates a new [ResidentRepositoryImpl] with the required API service dependency.
  ///
  /// [residentApiService] - The API service that will handle the actual resident operations
  ResidentRepositoryImpl(this.residentApiService);

  /// Retrieves the resident profile information for the user.
  ///
  /// Parameters:
  /// - [token]: The authentication token for the user
  ///
  /// Returns a [Future] that completes with a [Map<String, dynamic>] containing the resident data, or null if not found.
  @override
  Future<Map<String, dynamic>?> getResident(String token) {
    return residentApiService.getResident(token);
  }

}