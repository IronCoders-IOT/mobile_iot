import 'package:mobile_iot/profiles/domain/interfaces/profile_repository.dart';
import 'package:mobile_iot/profiles/domain/entities/profile.dart';

/// Use case for handling profile-related business logic.
///
/// This class acts as an intermediary between the presentation layer and the domain layer,
/// encapsulating the application-specific logic for profile operations such as creation,
/// update, and retrieval. It ensures that profile management follows the application's
/// business rules and requirements.
class ProfileUseCase {
  /// The profile repository that handles the actual profile operations.
  ///
  /// This dependency is injected through the constructor, following the
  /// dependency inversion principle. The use case depends on the abstract
  /// ProfileRepository interface rather than concrete implementations.
  final ProfileRepository _profileRepository;

  /// Creates a new ProfileUseCase instance with the required repository dependency.
  ///
  /// [profileRepository] - The profile repository that will handle the actual profile operations
  ProfileUseCase(this._profileRepository);

  /// Updates the profile information for the user.
  ///
  /// Parameters:
  /// - [token]: The authentication token for the user
  /// - [profile]: The profile entity containing updated user data
  ///
  /// Returns a [Future] that completes when the update operation is finished.
  Future<void> updateProfile(String token, Profile profile) {
    return _profileRepository.updateProfile(
      token,
      profile.firstName,
      profile.lastName,
      profile.email,
      profile.direction,
      profile.documentNumber,
      profile.documentType,
      profile.phone
    );
  }

  /// Creates a new profile for the user.
  ///
  /// Parameters:
  /// - [token]: The authentication token for the user
  /// - [profile]: The profile entity containing user data for creation
  ///
  /// Returns a [Future] that completes when the creation operation is finished.
  Future<void> createProfile(String token, Profile profile) {
    return _profileRepository.createProfile(
      token,
      profile.firstName,
      profile.lastName,
      profile.email,
      profile.direction,
      profile.documentNumber,
      profile.documentType,
      profile.phone
    );
  }

  /// Retrieves the profile information for the user.
  ///
  /// Parameters:
  /// - [token]: The authentication token for the user
  ///
  /// Returns a [Future] that completes with the [Profile] entity if found, or null if not found.
  Future<Profile?> getProfile(String token) {
    return _profileRepository.getProfile(token).then((data) {
      if (data == null) return null;
      return Profile.fromJson(data);
    });
  }

}