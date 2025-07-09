import 'package:equatable/equatable.dart';
import 'package:mobile_iot/analytics/domain/entities/report.dart';

/// Abstract base class for reports BLoC states.
/// 
/// This class defines the contract for all states that can be emitted
/// by the ReportsBloc. It extends Equatable to enable proper state
/// comparison and change detection.
/// 
/// All reports-related UI states should extend this class to ensure
/// consistent state management and UI updates.
abstract class ReportsState extends Equatable {
  const ReportsState();
}

/// Initial state when the reports BLoC is first created.
/// 
/// This state represents the starting point before any data
/// loading or user interaction has occurred.
class InitialReportsState extends ReportsState {
  const InitialReportsState();
  
  @override
  List<Object?> get props => [];
}

/// Loading state when reports data is being fetched.
/// 
/// This state is emitted when the application is loading
/// reports data from the data source, typically showing
/// a loading indicator in the UI.
class ReportsLoadingState extends ReportsState {
  const ReportsLoadingState();
  
  @override
  List<Object?> get props => [];
}

/// Loaded state when reports data has been successfully retrieved.
/// 
/// This state contains the loaded reports data and provides
/// filtering functionality based on search queries. It includes
/// both the original reports list and a computed filtered list.
/// 
/// Parameters:
/// - [reports]: The complete list of reports
/// - [searchQuery]: The current search query for filtering
class ReportsLoadedState extends ReportsState {
  final List<Report> reports;
  

  final String searchQuery;
  
  const ReportsLoadedState({required this.reports, this.searchQuery = ''});

  /// Returns the filtered list of reports based on the search query.
  /// 
  /// This getter performs case-insensitive filtering on report title,
  /// description, and status fields. If no search query is provided,
  /// returns the complete reports list.
  /// 
  /// Returns a filtered list of reports matching the search criteria.
  List<Report> get filteredReports {
    if (searchQuery.isEmpty) return reports;
    final searchLower = searchQuery.toLowerCase();
    return reports.where((report) {
      final titleLower = report.title.toLowerCase();
      final descriptionLower = report.description.toLowerCase();
      final statusLower = report.status.toLowerCase();
      return titleLower.contains(searchLower) ||
          descriptionLower.contains(searchLower) ||
          statusLower.contains(searchLower);
    }).toList();
  }

  @override
  List<Object?> get props => [reports, searchQuery];
}

/// Error state when reports data loading has failed.
/// 
/// This state is emitted when an error occurs during data loading,
/// containing an error message to display to the user.
/// 
/// Parameters:
/// - [message]: The error message describing what went wrong
class ReportsErrorState extends ReportsState {
  final String message;
  
  const ReportsErrorState(this.message);
  
  @override
  List<Object?> get props => [message];
} 