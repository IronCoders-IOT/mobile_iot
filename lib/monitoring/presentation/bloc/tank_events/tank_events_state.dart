import 'package:equatable/equatable.dart';
import 'package:mobile_iot/monitoring/domain/entities/event.dart';
import 'package:mobile_iot/shared/helpers/search_service.dart';

/// Abstract base class for tank events BLoC states.
/// 
/// This class defines the contract for all states that can be emitted
/// by the TankEventsBloc. It extends Equatable to enable proper state
/// comparison and change detection.
/// 
/// All tank events-related UI states should extend this class to ensure
/// consistent state management and UI updates.
abstract class TankEventsState extends Equatable {
  const TankEventsState();
}

/// Initial state when the tank events BLoC is first created.
/// 
/// This state represents the starting point before any data
/// loading or user interaction has occurred.
class InitialTankEventsState extends TankEventsState {
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
  final List<Event> events;
  
  final String searchQuery;
  
  const TankEventsLoadedState({required this.events, this.searchQuery = ''});

  /// Returns the filtered list of events based on the search query.
  /// 
  /// This getter uses the SearchService for scalable, language-agnostic search
  /// across all event fields including event type, quality value, level value, and device ID.
  /// The events are ordered from most recent to oldest for better user experience.
  /// 
  /// Returns a filtered and sorted list of events matching the search criteria.
  List<Event> get filteredEvents {
    final filtered = SearchService.fuzzySearch<Event>(
      items: events,
      searchQuery: searchQuery,
      getSearchableText: (event) => SearchService.createSearchableText([
        event.eventType,
        event.qualityValue,
        event.levelValue,
        event.deviceId.toString(),
      ]),
    );
    
    // Sort events from most recent to oldest
    // Since the API returns events in chronological order (oldest first),
    // we reverse the filtered list to show most recent events first
    return filtered.reversed.toList();
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
  final String message;
  
  const TankEventsErrorState(this.message);
  
  @override
  List<Object?> get props => [message];
} 

/// Session expired state when the user's session has expired.
class TankEventsSessionExpiredState extends TankEventsState {
  const TankEventsSessionExpiredState();

  @override
  List<Object?> get props => [];
} 