import 'package:equatable/equatable.dart';
import 'package:mobile_iot/profiles/domain/entities/profile.dart';

/// Abstract base class for profile edition BLoC events.
///
/// This class defines the contract for all events that can be dispatched
/// to the [ProfileEditionBloc]. It extends Equatable to enable proper state
/// comparison and change detection.
///
/// All profile edition-related user interactions and system events should
/// extend this class to ensure consistent event handling.
abstract class ProfileEditionEvent extends Equatable {
  /// Creates a profile edition event.
  const ProfileEditionEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load profile data from the server.
///
/// This event is dispatched when the application needs to load
/// profile data for editing, typically when the edit screen is first loaded
/// or when data needs to be refreshed.
class LoadProfileEvent extends ProfileEditionEvent {
  /// Creates a load profile event.
  const LoadProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Event to update profile information.
///
/// This event is dispatched when the user submits changes to their profile
/// information, triggering an update operation.
///
/// Parameters:
/// - [profile]: The profile entity containing updated user data
class UpdateProfileEvent extends ProfileEditionEvent {
  /// The profile entity containing updated user data.
  final Profile profile;

  /// Creates an update profile event.
  ///
  /// Parameters:
  /// - [profile]: The profile entity
  const UpdateProfileEvent({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// Event to reset the profile state.
///
/// This event is dispatched to reset the profile edition state to its initial state,
/// typically after a successful update or when the user cancels editing.
class ResetProfileEvent extends ProfileEditionEvent {
  /// Creates a reset profile event.
  const ResetProfileEvent();

  @override
  List<Object?> get props => [];
} 