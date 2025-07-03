import 'package:mobile_iot/profiles/domain/interfaces/profile_repository.dart';
import 'package:mobile_iot/profiles/domain/entities/profile.dart';

class ProfileUseCase {
  final ProfileRepository _profileRepository;

  ProfileUseCase(this._profileRepository);

  Future<void> updateProfile(String token,Profile profile) {
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
  Future<void> createProfile(String token,Profile profile) {
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
  Future<Profile?> getProfile(String token) {
    return _profileRepository.getProfile(token).then((data) {
      if (data == null) return null;
      return Profile.fromJson(data);
    });
  }

}