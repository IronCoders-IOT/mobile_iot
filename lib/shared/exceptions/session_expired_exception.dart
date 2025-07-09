/// Defines a custom exception for session expiration in the application.
///
/// This file provides the [SessionExpiredException] class, which is thrown when
/// a user's session has expired and re-authentication is required.

/// Exception thrown when the user's session has expired.
///
/// Used to indicate that the user must log in again due to session expiration.
class SessionExpiredException implements Exception {
  final String message;
  SessionExpiredException([this.message = 'Session expired. Please log in again.']);

  @override
  String toString() => 'SessionExpiredException: $message';
} 