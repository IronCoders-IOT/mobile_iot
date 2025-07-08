import 'package:mobile_iot/profiles/domain/interfaces/profile_repository.dart';
import 'package:mobile_iot/profiles/domain/entities/profile.dart';
import 'package:mobile_iot/profiles/infrastructure/service/profile_api_service.dart';

/// Implementation of [ProfileRepository] for profile operations using a remote API service.
///
/// This class delegates profile data operations (create, update, retrieve) to the [ProfileApiService],
/// handling the communication with the backend API.
class ProfileRepositoryImpl implements ProfileRepository {
  /// The API service used for profile operations.
  final ProfileApiService apiService;

  /// Creates a new [ProfileRepositoryImpl] with the required API service dependency.
  ///
  /// [apiService] - The API service that will handle the actual profile operations
  ProfileRepositoryImpl(this.apiService);

  /// Retrieves the profile information for the user.
  ///
  /// Parameters:
  /// - [token]: The authentication token for the user
  ///
  /// Returns a [Future] that completes with a [Map<String, dynamic>] containing the profile data, or null if not found.
  @override
  Future<Map<String, dynamic>?> getProfile(String token) {
    return apiService.getProfile(token);
  }

  /// Updates the profile information for the user.
  ///
  /// Parameters:
  /// - [token]: The authentication token for the user
  /// - [firstName]: The user's first name
  /// - [lastName]: The user's last name
  /// - [email]: The user's email address
  /// - [direction]: The user's address or direction
  /// - [documentNumber]: The user's document number
  /// - [documentType]: The type of document
  /// - [phone]: The user's phone number
  ///
  /// Returns a [Future] that completes when the update operation is finished.
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

  /// Creates a new profile for the user.
  ///
  /// Parameters:
  /// - [token]: The authentication token for the user
  /// - [firstName]: The user's first name
  /// - [lastName]: The user's last name
  /// - [email]: The user's email address
  /// - [direction]: The user's address or direction
  /// - [documentNumber]: The user's document number
  /// - [documentType]: The type of document
  /// - [phone]: The user's phone number
  ///
  /// Returns a [Future] that completes when the creation operation is finished.
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