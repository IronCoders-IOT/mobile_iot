import 'package:equatable/equatable.dart';

/// Abstract base class for water supply request BLoC events.
/// 
/// This class defines the contract for all events that can be dispatched
/// to the WaterSupplyRequestBloc. It extends Equatable to enable proper state
/// comparison and change detection.
/// 
/// All water supply request-related user interactions and system events should
/// extend this class to ensure consistent event handling.
abstract class WaterSupplyRequestEvent extends Equatable {
  const WaterSupplyRequestEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch water supply requests from the data source.
/// 
/// This event is dispatched when the application needs to load
/// water supply requests data, typically when the screen is first loaded
/// or when data needs to be refreshed.
class FetchWaterSupplyRequestsEvent extends WaterSupplyRequestEvent {
  const FetchWaterSupplyRequestsEvent();
}

/// Event to refresh water supply requests data.
/// 
/// This event is dispatched when the user manually refreshes
/// the water supply requests data, typically through pull-to-refresh
/// or a refresh button action.
class RefreshWaterSupplyRequestsEvent extends WaterSupplyRequestEvent {
  const RefreshWaterSupplyRequestsEvent();
}