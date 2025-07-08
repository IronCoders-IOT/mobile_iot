import 'package:equatable/equatable.dart';
import 'package:mobile_iot/analytics/domain/entities/event.dart';

/// Abstract base class for tank events BLoC states.
/// 
/// This class defines the contract for all states that can be emitted
/// by the TankEventsBloc. It extends Equatable to enable proper state
/// comparison and change detection.
/// 
/// All tank events-related UI states should extend this class to ensure
/// consistent state management and UI updates.
abstract class TankEventsState extends Equatable {
  /// Creates a tank events state.
  const TankEventsState();
}

/// Initial state when the tank events BLoC is first created.
/// 
/// This state represents the starting point before any data
/// loading or user interaction has occurred.
class InitialTankEventsState extends TankEventsState {
  /// Creates an initial tank events state.
  const InitialTankEventsState();
  
  @override
  List<Object?> get props => [];
}

/// Loading state when tank events data is being fetched.
/// 
/// This state is emitted when the application is loading
/// tank events data from the data source, typically showing
/// a loading indicator in the UI.
class TankEventsLoadingState extends TankEventsState {
  /// Creates a loading tank events state.
  const TankEventsLoadingState();
  
  @override
  List<Object?> get props => [];
}

/// Loaded state when tank events data has been successfully retrieved.
/// 
/// This state contains the loaded tank events data and provides
/// filtering functionality based on search queries. It includes
/// both the original events list and a computed filtered list.
/// 
/// Parameters:
/// - [events]: The complete list of tank events
/// - [searchQuery]: The current search query for filtering
class TankEventsLoadedState extends TankEventsState {
  /// The complete list of tank events retrieved from the data source.
  final List<Event> events;
  
  /// The current search query used for filtering events.
  /// Defaults to empty string if no search is active.
  final String searchQuery;
  
  /// Creates a loaded tank events state.
  /// 
  /// Parameters:
  /// - [events]: The list of tank events
  /// - [searchQuery]: Optional search query for filtering
  const TankEventsLoadedState({required this.events, this.searchQuery = ''});

  /// Returns the filtered list of events based on the search query.
  /// 
  /// This getter performs case-insensitive filtering on event type,
  /// quality value, and level value fields. If no search query is
  /// provided, returns the complete events list.
  /// 
  /// Returns a filtered list of events matching the search criteria.
  List<Event> get filteredEvents {
    if (searchQuery.isEmpty) return events;
    final searchLower = searchQuery.toLowerCase();
    return events.where((event) =>
      event.eventType.toLowerCase().contains(searchLower) ||
      event.qualityValue.toLowerCase().contains(searchLower) ||
      event.levelValue.toLowerCase().contains(searchLower)
    ).toList();
  }

  @override
  List<Object?> get props => [events, searchQuery];
}

/// Error state when tank events data loading has failed.
/// 
/// This state is emitted when an error occurs during data loading,
/// containing an error message to display to the user.
/// 
/// Parameters:
/// - [message]: The error message describing what went wrong
class TankEventsErrorState extends TankEventsState {
  /// The error message to display to the user.
  final String message;
  
  /// Creates an error tank events state.
  /// 
  /// Parameters:
  /// - [message]: The error message
  const TankEventsErrorState(this.message);
  
  @override
  List<Object?> get props => [message];
} 