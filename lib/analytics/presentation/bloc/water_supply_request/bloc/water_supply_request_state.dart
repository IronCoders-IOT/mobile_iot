import 'package:equatable/equatable.dart';
import 'package:mobile_iot/analytics/domain/entities/water_request.dart';

/// States for the WaterSupplyRequestBloc
abstract class WaterSupplyRequestState extends Equatable {
  const WaterSupplyRequestState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class WaterSupplyRequestInitialState extends WaterSupplyRequestState {}

/// Loading state while fetching requests
class WaterSupplyRequestLoadingState extends WaterSupplyRequestState {}

/// Loaded state with requests data
class WaterSupplyRequestLoadedState extends WaterSupplyRequestState {
  final List<WaterRequest> requests;

  const WaterSupplyRequestLoadedState(this.requests);

  @override
  List<Object?> get props => [requests];
}

/// Error state when fetching fails
class WaterSupplyRequestErrorState extends WaterSupplyRequestState {
  final String message;

  const WaterSupplyRequestErrorState(this.message);

  @override
  List<Object?> get props => [message];
} 