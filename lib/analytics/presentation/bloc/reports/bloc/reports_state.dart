import 'package:equatable/equatable.dart';
import 'package:mobile_iot/analytics/domain/entities/report.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();
}

class InitialReportsState extends ReportsState {
  @override
  List<Object?> get props => [];
}

class ReportsLoadingState extends ReportsState {
  @override
  List<Object?> get props => [];
}

class ReportsLoadedState extends ReportsState {
  final List<Report> reports;
  final String searchQuery;
  
  const ReportsLoadedState({required this.reports, this.searchQuery = ''});

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

class ReportsErrorState extends ReportsState {
  final String message;
  const ReportsErrorState(this.message);
  
  @override
  List<Object?> get props => [message];
} 