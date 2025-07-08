import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/iam/application/sign_in_use_case.dart';
import 'package:mobile_iot/iam/domain/entities/credentials.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/iam/presentation/bloc/auth/bloc/auth_event.dart';
import 'package:mobile_iot/iam/presentation/bloc/auth/bloc/auth_state.dart';

/// BLoC for managing authentication state and business logic.
///
/// This BLoC handles all authentication-related operations including user login,
/// logout, and authentication status checks. It coordinates between the presentation
/// layer and the business logic layer, managing the complete lifecycle of authentication
/// and session management.
///
/// The BLoC follows the BLoC pattern for state management and provides:
/// - User login with credentials
/// - Token storage and management
/// - Authentication state management
/// - Error handling for authentication failures
/// - Loading states during authentication
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Use case for sign-in operations.
  final SignInUseCase _signInUseCase;
  /// Service for secure storage operations (authentication tokens).
  final SecureStorageService _secureStorage;

  /// Creates an authentication BLoC with the required dependencies.
  ///
  /// Parameters:
  /// - [signInUseCase]: Use case for sign-in operations
  /// - [secureStorage]: Service for secure storage
  AuthBloc({
    required SignInUseCase signInUseCase,
    required SecureStorageService secureStorage,
  })  : _signInUseCase = signInUseCase,
        _secureStorage = secureStorage,
        super(AuthInitialState()) {
    // Register event handlers
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  /// Handles user login with credentials.
  ///
  /// This method performs the complete login process:
  /// 1. Emits loading state
  /// 2. Executes sign-in use case with provided credentials
  /// 3. Stores token if successful and emits success state
  /// 4. Emits error state if login fails
  ///
  /// Parameters:
  /// - [event]: The login event containing credentials
  /// - [emit]: The state emitter
  ///
  /// Emits:
  /// - [AuthLoadingState]
  /// - [AuthSuccessState]
  /// - [AuthErrorState]
  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final token = await _signInUseCase.execute(event.credentials);
      if (token != null) {
        await _secureStorage.saveToken(token);
        emit(AuthSuccessState(token: token));
      } else {
        emit(AuthErrorState('Login failed. Please check your credentials.'));
      }
    } catch (e) {
      emit(AuthErrorState('Authentication error: ${e.toString()}'));
    }
  }

  /// Handles user logout.
  ///
  /// This method deletes the authentication token and emits the logged out state.
  /// Emits an error state if logout fails.
  ///
  /// Parameters:
  /// - [event]: The logout event
  /// - [emit]: The state emitter
  ///
  /// Emits:
  /// - [AuthLoggedOutState]
  /// - [AuthErrorState]
  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _secureStorage.deleteToken();
      emit(AuthLoggedOutState());
    } catch (e) {
      emit(AuthErrorState('Logout error: ${e.toString()}'));
    }
  }

  /// Checks the current authentication status.
  ///
  /// This method retrieves the authentication token and emits the appropriate state
  /// based on whether the user is authenticated or not. Emits an error state if the
  /// check fails.
  ///
  /// Parameters:
  /// - [event]: The check auth status event
  /// - [emit]: The state emitter
  ///
  /// Emits:
  /// - [AuthAuthenticatedState]
  /// - [AuthUnauthenticatedState]
  /// - [AuthErrorState]
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final token = await _secureStorage.getToken();
      if (token != null) {
        emit(AuthAuthenticatedState(token: token));
      } else {
        emit(AuthUnauthenticatedState());
      }
    } catch (e) {
      emit(AuthErrorState('Error checking authentication status: ${e.toString()}'));
    }
  }
} 