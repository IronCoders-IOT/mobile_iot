import 'package:equatable/equatable.dart';

/// Events for the WaterSupplyRequestCreationBloc
abstract class WaterSupplyRequestCreationEvent extends Equatable {
  const WaterSupplyRequestCreationEvent();

  @override
  List<Object?> get props => [];
}

/// Event to create a new water supply request
class CreateWaterSupplyRequestEvent extends WaterSupplyRequestCreationEvent {
  final String liters;

  const CreateWaterSupplyRequestEvent({
    required this.liters,
  });

  @override
  List<Object?> get props => [liters];
} 