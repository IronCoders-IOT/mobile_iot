import 'package:equatable/equatable.dart';

/// Events for the ReportCreationBloc
abstract class ReportCreationEvent extends Equatable {
  const ReportCreationEvent();

  @override
  List<Object?> get props => [];
}

/// Event to create a new report
class CreateReportEvent extends ReportCreationEvent {
  final String title;
  final String description;

  const CreateReportEvent({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
} 