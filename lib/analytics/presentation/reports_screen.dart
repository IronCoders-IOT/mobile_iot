import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/profiles/infrastructure/service/resident_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/service/report_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/repositories/report_repository_impl.dart';
import 'package:mobile_iot/analytics/application/report_use_case.dart';
import 'package:mobile_iot/analytics/domain/entities/report.dart';
import 'package:mobile_iot/analytics/domain/logic/date_formatter.dart';
import 'package:mobile_iot/analytics/domain/logic/status_formatter.dart';
import 'package:mobile_iot/analytics/domain/logic/report_status_colors.dart';
import 'package:mobile_iot/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:mobile_iot/analytics/presentation/report_creation_screen.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_header.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_search_bar.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_empty_state.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_error_state.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_loading_state.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_list_card.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_status_badge.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_modal_bottom_sheet.dart';
import '../../l10n/app_localizations.dart';

import '../../shared/widgets/app_colors.dart';
import 'bloc/reports/reports_bloc.dart';
import 'bloc/reports/reports_event.dart';
import 'bloc/reports/reports_state.dart';
import '../../shared/widgets/session_expired_screen.dart';

/// A screen that displays a list of reports for the authenticated user.
/// 
/// This screen uses the BLoC pattern for state management and provides the following features:
/// - View all reports associated with the user
/// - Search reports by title or description
/// - Pull-to-refresh functionality
/// - Create new reports via floating action button
/// - View detailed report information in a modal
/// - Navigate to other app sections via bottom navigation
/// 
/// The screen automatically handles:
/// - Loading states while fetching data
/// - Error states with retry functionality
/// - Session expiration and automatic logout
/// - Empty states when no reports are found
/// - Report creation and management
///
class ReportsScreen extends StatelessWidget {
  /// Creates a reports screen.
  /// 
  /// The [key] parameter is optional and is passed to the superclass.
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReportsBloc>(
      create: (context) => ReportsBloc(
        reportUseCase: ReportUseCase(ReportRepositoryImpl(ReportApiService())),
        secureStorage: SecureStorageService(),
        residentApiService: ResidentApiService(),
      )..add(FetchReportsEvent()),
      child: BlocConsumer<ReportsBloc, ReportsState>(
        listener: (context, state) {
          if (state is ReportsSessionExpiredState) {
            Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
          }
        },
        builder: (context, state) {
          if (state is ReportsSessionExpiredState) {
            return SessionExpiredScreen(
              onLoginAgain: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              },
            );
          }
          return Scaffold(
            backgroundColor: AppColors.lightGray,
            body: SafeArea(
              child: Column(
                children: [
                  AppHeader(
                    title: AppLocalizations.of(context)!.reports,
                    onBack: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                  ),
                  if (state is ReportsLoadedState)
                    AppSearchBar(
                      controller: TextEditingController(text: state.searchQuery),
                      onChanged: (value) => context.read<ReportsBloc>().add(SearchReportsEvent(value)),
                      hintText: AppLocalizations.of(context)!.searchReports,
                    ),
                  Expanded(child: _buildBody(context, state)),
                ],
              ),
            ),
            bottomNavigationBar: AppBottomNavigationBar(
              currentIndex: 0,
              onTap: (index) {
                if (index == 1) Navigator.pushReplacementNamed(context, '/dashboard');
                if (index == 2) Navigator.pushReplacementNamed(context, '/profile');
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _createReport(context),
              backgroundColor: AppColors.primaryBlue,
              child: const Icon(Icons.add, color: Colors.white),
              tooltip: 'Create Report',
            ),
          );
        },
      ),
    );
  }

  /// Builds the main body content based on the current BLoC state.
  /// 
  /// This method handles different UI states:
  /// - [ReportsLoadingState]: Shows loading indicator
  /// - [ReportsErrorState]: Shows error message with retry button
  /// - [ReportsLoadedState]: Shows the list of reports with pull-to-refresh
  /// - Default: Shows loading indicator as fallback
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// - [state]: The current state from the ReportsBloc
  /// 
  /// Returns a widget that represents the appropriate UI for the current state.
  Widget _buildBody(BuildContext context, ReportsState state) {
    if (state is ReportsLoadingState) return const AppLoadingState();
    if (state is ReportsErrorState) {
      return AppErrorState(
        message: state.message,
        onRetry: () => context.read<ReportsBloc>().add(FetchReportsEvent()),
      );
    }
    if (state is ReportsLoadedState) {
      return RefreshIndicator(
        onRefresh: () async => context.read<ReportsBloc>().add(RefreshReportsEvent()),
        child: _buildReportsList(context, state),
      );
    }
    return const AppLoadingState();
  }

  /// Builds the list of reports when data is successfully loaded.
  /// 
  /// This method handles:
  /// - Empty state when no reports are found
  /// - List view with all reports when data exists
  /// - Pull-to-refresh functionality
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// - [state]: The loaded state containing reports data
  /// 
  /// Returns a widget that displays the reports list or empty state.
  Widget _buildReportsList(BuildContext context, ReportsLoadedState state) {
    final reports = state.filteredReports;
    
    if (reports.isEmpty) {
      return AppEmptyState(
        title: 'No reports found',
        subtitle: 'Pull down to refresh or create a new report',
        onAction: () => context.read<ReportsBloc>().add(RefreshReportsEvent()),
        actionText: 'Refresh',
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: reports.length,
      itemBuilder: (context, index) => _buildReportItem(context, reports[index]),
    );
  }

  /// Builds an individual report item card.
  /// 
  /// Each report item displays:
  /// - Report title
  /// - Status badge with appropriate colors
  /// - Description (truncated to 2 lines)
  /// - Creation date formatted for display
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// - [report]: The report entity to display
  /// 
  /// Returns a card widget representing a single report.
  Widget _buildReportItem(BuildContext context, Report report) {
    return AppListCard(
      onTap: () => _showReportDetails(context, report),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  report.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.darkBlue),
                ),
              ),
              AppStatusBadge(
                text: StatusFormatter.formatReportStatus(context, report.status),
                backgroundColor: ReportStatusColors.statusColor(report.status),
                textColor: ReportStatusColors.statusTextColor(report.status),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            report.description,
            style: const TextStyle(fontSize: 14, color: AppColors.mediumGray),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            '${AppLocalizations.of(context)!.created}: ${DateFormatter.formatEmissionDate(context, report.emissionDate)}',
            style: const TextStyle(fontSize: 12, color: AppColors.mediumGray),
          ),
        ],
      ),
    );
  }

  /// Shows a modal bottom sheet with detailed report information.
  /// 
  /// This method displays a comprehensive view of the report including:
  /// - Report icon with status-based colors
  /// - Full title and description
  /// - Status information
  /// - Creation date
  /// - Any additional report metadata
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// - [report]: The report entity to display details for
  void _showReportDetails(BuildContext context, Report report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppModalBottomSheet(
        title: AppLocalizations.of(context)!.reportDetails,
        onClose: () => Navigator.pop(context),
        children: [_buildReportDetailsContent(context, report)],
      ),
    );
  }

  /// Builds the content for the report details modal.
  /// 
  /// This method creates a detailed view of the report with:
  /// - Status-colored icon container
  /// - Full report title and description
  /// - Formatted status and creation date
  /// - Proper spacing and typography
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// - [report]: The report entity to display detailed information for
  /// 
  /// Returns a widget containing the formatted report details.
  Widget _buildReportDetailsContent(BuildContext context, Report report) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: ReportStatusColors.statusColor(report.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.description,
                  color: ReportStatusColors.statusTextColor(report.status),
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkBlue),
                    ),
                    AppStatusBadge(
                      text: StatusFormatter.formatReportStatus(context, report.status),
                      backgroundColor: ReportStatusColors.statusColor(report.status),
                      textColor: ReportStatusColors.statusTextColor(report.status),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          Text(AppLocalizations.of(context)!.details, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.darkBlue)),
          const SizedBox(height: 12),
            _buildDetailItem(AppLocalizations.of(context)!.description, report.description),
            _buildDetailItem(AppLocalizations.of(context)!.status, StatusFormatter.formatReportStatus(context, report.status)),
            _buildDetailItem(AppLocalizations.of(context)!.created, DateFormatter.formatEmissionDate(context, report.emissionDate)),
          const SizedBox(height: 24),
          Text(AppLocalizations.of(context)!.actions, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.darkBlue)),
          const SizedBox(height: 12),
            _buildActionItem(AppLocalizations.of(context)!.reviewReportDetails),
            _buildActionItem(AppLocalizations.of(context)!.updateStatusIfNeeded),
            _buildActionItem(AppLocalizations.of(context)!.contactSupportForAssistance),
        ],
      ),
    );
  }

  /// Builds a detail item row for the report details modal.
  /// 
  /// This method creates a consistent layout for displaying key-value pairs
  /// with proper spacing and typography.
  /// 
  /// Parameters:
  /// - [label]: The label text (e.g., "Description", "Status")
  /// - [value]: The value text to display
  /// 
  /// Returns a row widget with label and value properly formatted.
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkBlue)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14, color: AppColors.mediumGray))),
        ],
      ),
    );
  }

  /// Builds an action item row for the report details modal.
  /// 
  /// This method creates a bulleted list item with a small blue dot
  /// and proper spacing for action suggestions.
  /// 
  /// Parameters:
  /// - [action]: The action text to display
  /// 
  /// Returns a row widget with bullet point and action text.
  Widget _buildActionItem(String action) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(action, style: const TextStyle(fontSize: 14, color: AppColors.mediumGray, height: 1.4))),
        ],
      ),
    );
  }

  /// Navigates to the report creation screen and refreshes the reports list on success.
  /// 
  /// This method handles the floating action button tap and:
  /// - Navigates to the ReportCreationScreen
  /// - Waits for the result from the creation screen
  /// - Refreshes the reports list if a new report was created successfully
  /// 
  /// Parameters:
  /// - [context]: The build context for navigation
  /// 
  /// Returns a Future that completes when the creation flow is finished.
  Future<void> _createReport(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReportCreationScreen()),
    );
    if (result == true) {
      context.read<ReportsBloc>().add(RefreshReportsEvent());
    }
  }
}

