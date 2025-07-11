import 'package:equatable/equatable.dart';

/// Abstract base class for tank events BLoC events.
/// 
/// This class defines the contract for all events that can be dispatched
/// to the TankEventsBloc. It extends Equatable to enable proper state
/// comparison and change detection.
/// 
/// All tank events-related user interactions and system events should
/// extend this class to ensure consistent event handling.
abstract class TankEventsEvent extends Equatable {
  const TankEventsEvent();
}

/// Event to fetch tank events from the data source.
/// 
/// This event is dispatched when the application needs to load
/// tank events data, typically when the screen is first loaded
/// or when data needs to be refreshed.
class FetchTankEventsEvent extends TankEventsEvent {
  final int? deviceId;
  const FetchTankEventsEvent({this.deviceId});
  
  @override
  List<Object?> get props => [deviceId];
}

/// Event to search through tank events with a specific query.
/// 
/// This event is dispatched when the user performs a search
/// operation on the tank events list, filtering events based
/// on the provided search query.
/// 
/// Parameters:
/// - [query]: The search query string to filter events
class SearchTankEventsEvent extends TankEventsEvent {
  final String query;
  
  const SearchTankEventsEvent(this.query);
  
  @override
  List<Object?> get props => [query];
}

/// Event to refresh tank events data.
/// 
/// This event is dispatched when the user manually refreshes
/// the tank events data, typically through pull-to-refresh
/// or a refresh button action.
class RefreshTankEventsEvent extends TankEventsEvent {
  const RefreshTankEventsEvent();
  
  @override
  List<Object?> get props => [];
} 