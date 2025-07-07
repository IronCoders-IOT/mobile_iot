import 'package:equatable/equatable.dart';
import 'package:mobile_iot/analytics/domain/entities/event.dart';

abstract class TankEventsState extends Equatable {
  const TankEventsState();
}

class InitialTankEventsState extends TankEventsState {
  @override
  List<Object?> get props => [];
}

class TankEventsLoadingState extends TankEventsState {
  @override
  List<Object?> get props => [];
}

class TankEventsLoadedState extends TankEventsState {
  final List<Event> events;
  final String searchQuery;
  
  const TankEventsLoadedState({required this.events, this.searchQuery = ''});

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

class TankEventsErrorState extends TankEventsState {
  final String message;
  const TankEventsErrorState(this.message);
  
  @override
  List<Object?> get props => [message];
} 