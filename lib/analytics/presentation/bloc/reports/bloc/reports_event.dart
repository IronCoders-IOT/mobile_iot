import 'package:equatable/equatable.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();
}

class FetchReportsEvent extends ReportsEvent {
  @override
  List<Object?> get props => [];
}

class SearchReportsEvent extends ReportsEvent {
  final String query;
  const SearchReportsEvent(this.query);
  
  @override
  List<Object?> get props => [query];
}

class RefreshReportsEvent extends ReportsEvent {
  @override
  List<Object?> get props => [];
} 