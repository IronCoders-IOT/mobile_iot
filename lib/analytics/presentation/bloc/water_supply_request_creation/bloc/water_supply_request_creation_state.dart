import 'package:equatable/equatable.dart';

/// States for the WaterSupplyRequestCreationBloc
abstract class WaterSupplyRequestCreationState extends Equatable {
  const WaterSupplyRequestCreationState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class WaterSupplyRequestCreationInitialState extends WaterSupplyRequestCreationState {}

/// Loading state while creating request
class WaterSupplyRequestCreationLoadingState extends WaterSupplyRequestCreationState {}

/// Success state when request is created
class WaterSupplyRequestCreationSuccessState extends WaterSupplyRequestCreationState {
  final int liters;

  const WaterSupplyRequestCreationSuccessState(this.liters);

  @override
  List<Object?> get props => [liters];
}

/// Error state when creation fails
class WaterSupplyRequestCreationErrorState extends WaterSupplyRequestCreationState {
  final String message;

  const WaterSupplyRequestCreationErrorState(this.message);

  @override
  List<Object?> get props => [message];
} 