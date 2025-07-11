import 'package:equatable/equatable.dart';
import 'package:mobile_iot/iam/domain/entities/credentials.dart';

/// Abstract base class for authentication BLoC events.
///
/// This class defines the contract for all events that can be dispatched
/// to the [AuthBloc]. It extends Equatable to enable proper state
/// comparison and change detection.
///
/// All authentication-related user interactions and system events should
/// extend this class to ensure consistent event handling.
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Event to perform user login with credentials.
///
/// This event is dispatched when the user attempts to log in
/// with their credentials.
///
/// Parameters:
/// - [credentials]: The user's authentication credentials
class SignInEvent extends LoginEvent {
  final Credentials credentials;

  const SignInEvent({required this.credentials});

  @override
  List<Object?> get props => [credentials];
}

/// Event to perform user logout.
///
/// This event is dispatched when the user logs out of the application.
class LogoutEvent extends LoginEvent {
  const LogoutEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check current authentication status.
///
/// This event is dispatched to check whether the user is currently authenticated.
class CheckAuthStatusEvent extends LoginEvent {
  const CheckAuthStatusEvent();

  @override
  List<Object?> get props => [];
} 