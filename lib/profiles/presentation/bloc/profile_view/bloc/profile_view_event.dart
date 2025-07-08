import 'package:equatable/equatable.dart';

/// Abstract base class for profile view BLoC events.
///
/// This class defines the contract for all events that can be dispatched
/// to the [ProfileViewBloc]. It extends Equatable to enable proper state
/// comparison and change detection.
///
/// All profile view-related user interactions and system events should
/// extend this class to ensure consistent event handling.
abstract class ProfileViewEvent extends Equatable {
  /// Creates a profile view event.
  const ProfileViewEvent();
}

/// Event to load profile data for display.
///
/// This event is dispatched when the application needs to load
/// profile data, typically when the screen is first loaded
/// or when data needs to be refreshed.
class LoadProfileViewEvent extends ProfileViewEvent {
  /// Creates a load profile view event.
  const LoadProfileViewEvent();

  @override
  List<Object?> get props => [];
}

/// Event to refresh profile data.
///
/// This event is dispatched when the user manually refreshes
/// the profile data, typically through pull-to-refresh
/// or a refresh button action.
class RefreshProfileViewEvent extends ProfileViewEvent {
  /// Creates a refresh profile view event.
  const RefreshProfileViewEvent();

  @override
  List<Object?> get props => [];
} 