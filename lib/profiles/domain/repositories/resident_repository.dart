/// Abstract repository interface for resident operations.
///
/// This interface defines the contract for resident-related data operations
abstract class ResidentRepository {
  /// Retrieves the resident profile information for the user.
  ///
  /// Parameters:
  /// - [token]: The authentication token for the user
  ///
  /// Returns a [Future] that completes with a [Map<String, dynamic>] containing the resident data, or null if not found.
  Future<Map<String, dynamic>?> getResident(String token);
}