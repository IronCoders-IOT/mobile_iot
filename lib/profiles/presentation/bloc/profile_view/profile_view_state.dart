import 'package:equatable/equatable.dart';
import 'package:mobile_iot/profiles/domain/entities/profile.dart';

/// Abstract base class for profile view BLoC states.
///
/// This class defines the contract for all states that can be emitted
/// by the [ProfileViewBloc]. It extends Equatable to enable proper state
/// comparison and change detection.
///
/// All profile view-related UI states should extend this class to ensure
/// consistent state management and UI updates.
abstract class ProfileViewState extends Equatable {
  const ProfileViewState();
}

/// Initial state when the profile view BLoC is first created.
///
/// This state represents the starting point before any data
/// loading or user interaction has occurred.
class ProfileViewInitialState extends ProfileViewState {
  const ProfileViewInitialState();

  @override
  List<Object?> get props => [];
}

/// Loading state when profile data is being fetched.
///
/// This state is emitted when the application is loading
/// profile data from the data source, typically showing
/// a loading indicator in the UI.
class ProfileViewLoadingState extends ProfileViewState {
  const ProfileViewLoadingState();

  @override
  List<Object?> get props => [];
}

/// Loaded state when profile data has been successfully retrieved.
///
/// This state contains the loaded profile data.
///
/// Parameters:
/// - [profile]: The loaded profile entity
class ProfileViewLoadedState extends ProfileViewState {
  final Profile profile;

  const ProfileViewLoadedState({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// Error state when profile data loading has failed.
///
/// This state is emitted when an error occurs during data loading,
/// containing an error message to display to the user.
///
/// Parameters:
/// - [message]: The error message describing what went wrong
class ProfileViewErrorState extends ProfileViewState {
  final String message;

  const ProfileViewErrorState(this.message);

  @override
  List<Object?> get props => [message];
} 