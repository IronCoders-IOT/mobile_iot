import 'package:mobile_iot/profiles/domain/repositories/profile_repository.dart';
import 'package:mobile_iot/profiles/domain/entities/profile.dart';

/// Use case for handling profile-related business logic.
class ProfileUseCase {
  final ProfileRepository _profileRepository;

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
      profile.firstName!,
      profile.lastName!,
      profile.email!,
      profile.direction!,
      profile.documentNumber!,
      profile.documentType!,
      profile.phone!
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
      final profile = Profile.fromJson(data);
      return Profile.fromJson(data);

    });
  }

}