import 'package:equatable/equatable.dart';

/// Events for the WaterSupplyRequestBloc
abstract class WaterSupplyRequestEvent extends Equatable {
  const WaterSupplyRequestEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch water supply requests
class FetchWaterSupplyRequestsEvent extends WaterSupplyRequestEvent {}

/// Event to refresh water supply requests
class RefreshWaterSupplyRequestsEvent extends WaterSupplyRequestEvent {} 