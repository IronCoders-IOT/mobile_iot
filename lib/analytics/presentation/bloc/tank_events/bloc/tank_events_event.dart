import 'package:equatable/equatable.dart';

abstract class TankEventsEvent extends Equatable {
  const TankEventsEvent();
}

class FetchTankEventsEvent extends TankEventsEvent {
  @override
  List<Object?> get props => [];
}

class SearchTankEventsEvent extends TankEventsEvent {
  final String query;
  const SearchTankEventsEvent(this.query);
  
  @override
  List<Object?> get props => [query];
}

class RefreshTankEventsEvent extends TankEventsEvent {
  @override
  List<Object?> get props => [];
} 