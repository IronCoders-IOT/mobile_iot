import 'package:equatable/equatable.dart';

/// Abstract base class for report creation BLoC events.
/// 
/// This class defines the contract for all events that can be dispatched
/// to the ReportCreationBloc. It extends Equatable to enable proper state
/// comparison and change detection.
/// 
/// All report creation-related user interactions and system events should
/// extend this class to ensure consistent event handling.
abstract class ReportCreationEvent extends Equatable {
  const ReportCreationEvent();

  @override
  List<Object?> get props => [];
}

/// Event to create a new report in the system.
/// 
/// This event is dispatched when the user submits a new report
/// with the required title and description. The BLoC will handle
/// the report creation process and update the UI state accordingly.
/// 
/// Parameters:
/// - [title]: The title of the report
/// - [description]: The detailed description of the issue or observation
class CreateReportEvent extends ReportCreationEvent {
  /// The title of the report to be created.
  final String title;
  
  /// The detailed description of the report.
  final String description;

  const CreateReportEvent({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
} 