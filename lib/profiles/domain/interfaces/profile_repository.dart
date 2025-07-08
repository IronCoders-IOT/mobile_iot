/// Abstract repository interface for profile operations.
///
/// This interface defines the contract for profile-related data operations, including
/// creation, update, and retrieval. Implementations should handle the actual data
/// persistence and retrieval logic, whether from a remote API, local database, or other sources.
abstract class ProfileRepository {
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
  Future<void> updateProfile(String token, String firstName, String lastName, String email, String direction, String documentNumber, String documentType, String phone);

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
  Future<void> createProfile(String token, String firstName, String lastName, String email, String direction, String documentNumber, String documentType, String phone);

  /// Retrieves the profile information for the user.
  ///
  /// Parameters:
  /// - [token]: The authentication token for the user
  ///
  /// Returns a [Future] that completes with a [Map<String, dynamic>] containing the profile data, or null if not found.
  Future<Map<String, dynamic>?> getProfile(String token);

}