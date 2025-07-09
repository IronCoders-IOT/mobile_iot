/// Abstract repository interface for resident operations.
///
/// This interface defines the contract for resident-related data operations, specifically
/// the retrieval of resident profile information. Implementations should handle the actual
/// data retrieval logic, whether from a remote API, local database, or other sources.
abstract class ResidentRepository {
  /// Retrieves the resident profile information for the user.
  ///
  /// Parameters:
  /// - [token]: The authentication token for the user
  ///
  /// Returns a [Future] that completes with a [Map<String, dynamic>] containing the resident data, or null if not found.
  Future<Map<String, dynamic>?> getResident(String token);
}