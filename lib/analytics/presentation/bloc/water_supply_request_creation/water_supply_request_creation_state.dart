import 'package:equatable/equatable.dart';

/// Abstract base class for water supply request creation BLoC states.
/// 
/// This class defines the contract for all states that can be emitted
/// by the WaterSupplyRequestCreationBloc. It extends Equatable to enable proper state
/// comparison and change detection.
/// 
/// All water supply request creation-related UI states should extend this class to ensure
/// consistent state management and UI updates.
abstract class WaterSupplyRequestCreationState extends Equatable {
  const WaterSupplyRequestCreationState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the water supply request creation BLoC is first created.
/// 
/// This state represents the starting point before any request creation
/// process has been initiated.
class WaterSupplyRequestCreationInitialState extends WaterSupplyRequestCreationState {
  const WaterSupplyRequestCreationInitialState();
}

/// Loading state while creating a water supply request.
/// 
/// This state is emitted when the application is processing
/// a water supply request creation request, typically showing a loading indicator
/// in the UI to inform the user that the operation is in progress.
class WaterSupplyRequestCreationLoadingState extends WaterSupplyRequestCreationState {
  const WaterSupplyRequestCreationLoadingState();
}

/// Success state when a water supply request has been successfully created.
/// 
/// This state is emitted when the water supply request creation process completes
/// successfully, containing the amount of water that was requested.
/// 
/// Parameters:
/// - [liters]: The amount of water requested in liters
class WaterSupplyRequestCreationSuccessState extends WaterSupplyRequestCreationState {
  final int liters;

  const WaterSupplyRequestCreationSuccessState(this.liters);

  @override
  List<Object?> get props => [liters];
}

/// Error state when water supply request creation fails.
/// 
/// This state is emitted when an error occurs during the water supply request
/// creation process, containing an error message to display to the user.
/// 
/// Parameters:
/// - [message]: The error message describing what went wrong
class WaterSupplyRequestCreationErrorState extends WaterSupplyRequestCreationState {
  final String message;

  const WaterSupplyRequestCreationErrorState(this.message);

  @override
  List<Object?> get props => [message];
} 