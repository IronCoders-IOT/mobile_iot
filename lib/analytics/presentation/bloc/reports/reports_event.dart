import 'package:equatable/equatable.dart';

/// Abstract base class for reports BLoC events.
/// 
/// This class defines the contract for all events that can be dispatched
/// to the ReportsBloc. It extends Equatable to enable proper state
/// comparison and change detection.
/// 
/// All reports-related user interactions and system events should
/// extend this class to ensure consistent event handling.
abstract class ReportsEvent extends Equatable {
  const ReportsEvent();
}

/// Event to fetch reports from the data source.
/// 
/// This event is dispatched when the application needs to load
/// reports data, typically when the screen is first loaded
/// or when data needs to be refreshed.
class FetchReportsEvent extends ReportsEvent {
  /// Creates a fetch reports event.
  const FetchReportsEvent();
  
  @override
  List<Object?> get props => [];
}

/// Event to search through reports with a specific query.
/// 
/// This event is dispatched when the user performs a search
/// operation on the reports list, filtering reports based
/// on the provided search query.
/// 
/// Parameters:
/// - [query]: The search query string to filter reports
class SearchReportsEvent extends ReportsEvent {
  /// The search query to filter reports.
  final String query;
  
  const SearchReportsEvent(this.query);
  
  @override
  List<Object?> get props => [query];
}

/// Event to refresh reports data.
/// 
/// This event is dispatched when the user manually refreshes
/// the reports data, typically through pull-to-refresh
/// or a refresh button action.
class RefreshReportsEvent extends ReportsEvent {
  const RefreshReportsEvent();
  
  @override
  List<Object?> get props => [];
} 