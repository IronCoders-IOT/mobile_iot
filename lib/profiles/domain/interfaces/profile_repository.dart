abstract class ProfileRepository {

  Future<void> updateProfile(String token,String firstName, String lastName, String email, String direction, String documentNumber, String documentType, String phone);
  Future<void> createProfile(String token,String firstName, String lastName, String email, String direction, String documentNumber, String documentType, String phone);
  Future<Map<String, dynamic>?> getProfile(String token);

}