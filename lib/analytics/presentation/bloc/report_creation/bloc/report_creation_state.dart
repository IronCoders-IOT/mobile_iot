import 'package:equatable/equatable.dart';

/// States for the ReportCreationBloc
abstract class ReportCreationState extends Equatable {
  const ReportCreationState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ReportCreationInitialState extends ReportCreationState {}

/// Loading state while creating report
class ReportCreationLoadingState extends ReportCreationState {}

/// Success state when report is created
class ReportCreationSuccessState extends ReportCreationState {}

/// Error state when creation fails
class ReportCreationErrorState extends ReportCreationState {
  final String message;

  const ReportCreationErrorState(this.message);

  @override
  List<Object?> get props => [message];
} 