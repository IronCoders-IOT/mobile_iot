import 'package:equatable/equatable.dart';

/// Abstract base class for report creation BLoC states.
/// 
/// This class defines the contract for all states that can be emitted
/// by the ReportCreationBloc. It extends Equatable to enable proper state
/// comparison and change detection.
/// 
/// All report creation-related UI states should extend this class to ensure
/// consistent state management and UI updates.
abstract class ReportCreationState extends Equatable {
  /// Creates a report creation state.
  const ReportCreationState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the report creation BLoC is first created.
/// 
/// This state represents the starting point before any report creation
/// process has been initiated.
class ReportCreationInitialState extends ReportCreationState {
  /// Creates an initial report creation state.
  const ReportCreationInitialState();
}

/// Loading state while creating a report.
/// 
/// This state is emitted when the application is processing
/// a report creation request, typically showing a loading indicator
/// in the UI to inform the user that the operation is in progress.
class ReportCreationLoadingState extends ReportCreationState {
  /// Creates a loading report creation state.
  const ReportCreationLoadingState();
}

/// Success state when a report has been successfully created.
/// 
/// This state is emitted when the report creation process completes
/// successfully, indicating that the report has been saved to the
/// system and the user can proceed or navigate away.
class ReportCreationSuccessState extends ReportCreationState {
  /// Creates a success report creation state.
  const ReportCreationSuccessState();
}

/// Error state when report creation fails.
/// 
/// This state is emitted when an error occurs during the report
/// creation process, containing an error message to display to
/// the user.
/// 
/// Parameters:
/// - [message]: The error message describing what went wrong
class ReportCreationErrorState extends ReportCreationState {
  /// The error message to display to the user.
  final String message;

  const ReportCreationErrorState(this.message);

  @override
  List<Object?> get props => [message];
} 

/// Session expired state when the user's session has expired.
class ReportCreationSessionExpiredState extends ReportCreationState {
  const ReportCreationSessionExpiredState();

  @override
  List<Object?> get props => [];
} 