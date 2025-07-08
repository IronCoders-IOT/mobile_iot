import 'package:equatable/equatable.dart';
import 'package:mobile_iot/profiles/domain/entities/profile.dart';

/// Abstract base class for profile edition BLoC states.
///
/// This class defines the contract for all states that can be emitted
/// by the [ProfileEditionBloc]. It extends Equatable to enable proper state
/// comparison and change detection.
///
/// All profile edition-related UI states should extend this class to ensure
/// consistent state management and UI updates.
abstract class ProfileEditionState extends Equatable {
  /// Creates a profile edition state.
  const ProfileEditionState();
}

/// Initial state when the profile edition BLoC is first created.
///
/// This state represents the starting point before any data
/// loading or user interaction has occurred.
class ProfileEditionInitialState extends ProfileEditionState {
  /// Creates an initial profile edition state.
  const ProfileEditionInitialState();

  @override
  List<Object?> get props => [];
}

/// Loading state when profile data is being fetched.
///
/// This state is emitted when the application is loading
/// profile data from the data source, typically showing
/// a loading indicator in the UI.
class ProfileEditionLoadingState extends ProfileEditionState {
  /// Creates a loading profile edition state.
  const ProfileEditionLoadingState();

  @override
  List<Object?> get props => [];
}

/// Loaded state when profile data has been successfully retrieved.
///
/// This state contains the loaded profile data.
///
/// Parameters:
/// - [profile]: The loaded profile entity
class ProfileEditionLoadedState extends ProfileEditionState {
  /// The loaded profile entity.
  final Profile profile;

  /// Creates a loaded profile edition state.
  ///
  /// Parameters:
  /// - [profile]: The loaded profile entity
  const ProfileEditionLoadedState({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// Updating state when profile data is being updated.
///
/// This state is emitted when the application is updating
/// profile data, typically showing a loading indicator in the UI.
class ProfileEditionUpdatingState extends ProfileEditionState {
  /// Creates an updating profile edition state.
  const ProfileEditionUpdatingState();

  @override
  List<Object?> get props => [];
}

/// Updated state when profile data has been successfully updated.
///
/// This state contains the updated profile data.
///
/// Parameters:
/// - [profile]: The updated profile entity
class ProfileEditionUpdatedState extends ProfileEditionState {
  /// The updated profile entity.
  final Profile profile;

  /// Creates an updated profile edition state.
  ///
  /// Parameters:
  /// - [profile]: The updated profile entity
  const ProfileEditionUpdatedState({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// Error state when profile data loading or updating has failed.
///
/// This state is emitted when an error occurs during data loading or updating,
/// containing an error message to display to the user.
///
/// Parameters:
/// - [message]: The error message describing what went wrong
class ProfileEditionErrorState extends ProfileEditionState {
  /// The error message to display to the user.
  final String message;

  /// Creates an error profile edition state.
  ///
  /// Parameters:
  /// - [message]: The error message
  const ProfileEditionErrorState(this.message);

  @override
  List<Object?> get props => [message];
} 