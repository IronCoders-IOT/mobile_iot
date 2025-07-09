import 'package:equatable/equatable.dart';

/// Abstract base class for water supply request creation BLoC events.
/// 
/// This class defines the contract for all events that can be dispatched
/// to the WaterSupplyRequestCreationBloc. It extends Equatable to enable proper state
/// comparison and change detection.
/// 
/// All water supply request creation-related user interactions and system events should
/// extend this class to ensure consistent event handling.
abstract class WaterSupplyRequestCreationEvent extends Equatable {
  const WaterSupplyRequestCreationEvent();

  @override
  List<Object?> get props => [];
}

/// Event to create a new water supply request in the system.
/// 
/// This event is dispatched when the user submits a new water supply request
/// with the required amount in liters. The BLoC will handle the request creation
/// process and update the UI state accordingly.
/// 
/// Parameters:
/// - [liters]: The amount of water requested in liters
class CreateWaterSupplyRequestEvent extends WaterSupplyRequestCreationEvent {
  final String liters;

  const CreateWaterSupplyRequestEvent({
    required this.liters,
  });

  @override
  List<Object?> get props => [liters];
} 