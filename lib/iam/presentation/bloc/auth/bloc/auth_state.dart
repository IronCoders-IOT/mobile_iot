import 'package:equatable/equatable.dart';

/// Abstract base class for authentication BLoC states.
///
/// This class defines the contract for all states that can be emitted
/// by the [AuthBloc]. It extends Equatable to enable proper state
/// comparison and change detection.
///
/// All authentication-related UI states should extend this class to ensure
/// consistent state management and UI updates.
abstract class AuthState extends Equatable {
  /// Creates an authentication state.
  const AuthState();
}

/// Initial state when the authentication BLoC is first created.
///
/// This state represents the starting point before any authentication
/// action has occurred.
class AuthInitialState extends AuthState {
  /// Creates an initial authentication state.
  const AuthInitialState();

  @override
  List<Object?> get props => [];
}

/// State when authentication is in progress.
///
/// This state is emitted when the application is performing
/// authentication operations, typically showing a loading indicator.
class AuthLoadingState extends AuthState {
  /// Creates a loading authentication state.
  const AuthLoadingState();

  @override
  List<Object?> get props => [];
}

/// State when authentication is successful.
///
/// This state is emitted when the user has successfully authenticated.
///
/// Parameters:
/// - [token]: The authentication token
class AuthSuccessState extends AuthState {
  /// The authentication token.
  final String token;

  /// Creates a success authentication state.
  ///
  /// Parameters:
  /// - [token]: The authentication token
  const AuthSuccessState({required this.token});

  @override
  List<Object?> get props => [token];
}

/// State when user is authenticated.
///
/// This state is emitted when the user is currently authenticated.
///
/// Parameters:
/// - [token]: The authentication token
class AuthAuthenticatedState extends AuthState {
  /// The authentication token.
  final String token;

  /// Creates an authenticated state.
  ///
  /// Parameters:
  /// - [token]: The authentication token
  const AuthAuthenticatedState({required this.token});

  @override
  List<Object?> get props => [token];
}

/// State when user is not authenticated.
///
/// This state is emitted when the user is not currently authenticated.
class AuthUnauthenticatedState extends AuthState {
  /// Creates an unauthenticated state.
  const AuthUnauthenticatedState();

  @override
  List<Object?> get props => [];
}

/// State when user has logged out.
///
/// This state is emitted when the user has successfully logged out.
class AuthLoggedOutState extends AuthState {
  /// Creates a logged out state.
  const AuthLoggedOutState();

  @override
  List<Object?> get props => [];
}

/// State when an error occurs during authentication.
///
/// This state is emitted when an error occurs during authentication
/// operations, containing an error message to display to the user.
///
/// Parameters:
/// - [message]: The error message describing what went wrong
class AuthErrorState extends AuthState {
  /// The error message to display to the user.
  final String message;

  /// Creates an error authentication state.
  ///
  /// Parameters:
  /// - [message]: The error message
  const AuthErrorState(this.message);

  @override
  List<Object?> get props => [message];
} 