import 'package:flutter/material.dart';
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
import 'package:mobile_iot/shared/exceptions/session_expired_exception.dart';

import '../../shared/widgets/app_colors.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<Report> reports = [];
  bool _isLoading = true;
  String? _error;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final storage = SecureStorageService();
      final token = await storage.getToken();
      if (token == null) throw Exception('No authentication token found');
      final residentJson = await ResidentApiService().getResident(token);
      if (residentJson == null || residentJson['id'] == null) throw Exception('Resident not found');
      final residentId = residentJson['id'];
      final reportUseCase = ReportUseCase(ReportRepositoryImpl(ReportApiService()));
      final fetchedReports = await reportUseCase.getReportByResidentId(token, residentId);
      setState(() {
        reports = fetchedReports;
        _isLoading = false;
      });
    } on SessionExpiredException catch (e) {
      await SecureStorageService().deleteToken();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshReports() async {
    await _fetchReports();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Report> get filteredReports {
    if (_searchQuery.isEmpty) {
      return reports;
    }
    return reports.where((report) {
      final titleLower = report.title.toLowerCase();
      final descriptionLower = report.description.toLowerCase();
      final statusLower = report.status.toLowerCase();
      final searchLower = _searchQuery.toLowerCase();
      return titleLower.contains(searchLower) ||
          descriptionLower.contains(searchLower) ||
          statusLower.contains(searchLower);
    }).toList();
  }

  void _showReportDetails(Report report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppModalBottomSheet(
        title: 'Report Details',
        onClose: () => Navigator.pop(context),
        children: [_buildReportDetailsContent(report)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'REPORTS',
              onBack: () => Navigator.pushReplacementNamed(context, '/dashboard'),
            ),
            AppSearchBar(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              hintText: 'Search reports...',
            ),
            Expanded(
              child: _isLoading
                  ? const AppLoadingState()
                  : _error != null
                      ? AppErrorState(
                          message: _error!,
                          onRetry: _fetchReports,
                        )
                      : RefreshIndicator(
                          onRefresh: _refreshReports,
                          child: _buildReportsList(),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on reports
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReportCreationScreen()),
          );
          // Refresh reports after creating a new one
          if (result == true) {
            _refreshReports();
          }
        },
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Create Report',
      ),
    );
  }

  Widget _buildReportsList() {
    final reportsToShow = filteredReports;
    if (reportsToShow.isEmpty) {
      return AppEmptyState(
        title: 'No reports found',
        subtitle: 'Pull down to refresh or create a new report',
        onAction: _refreshReports,
        actionText: 'Refresh',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: reportsToShow.length,
      itemBuilder: (context, index) {
        final report = reportsToShow[index];
        return _buildReportItem(report, index);
      },
    );
  }

  Widget _buildReportItem(Report report, int index) {
    return AppListCard(
      onTap: () => _showReportDetails(report),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  report.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlue,
                  ),
                ),
              ),
              AppStatusBadge(
                text: StatusFormatter.formatReportStatus(report.status),
                backgroundColor: ReportStatusColors.statusColor(report.status),
                textColor: ReportStatusColors.statusTextColor(report.status),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Description
          Text(
            report.description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.mediumGray,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          // Date
          Text(
            'Created: ${DateFormatter.formatEmissionDate(report.emissionDate)}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportDetailsContent(Report report) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    AppStatusBadge(
                      text: StatusFormatter.formatReportStatus(report.status),
                      backgroundColor: ReportStatusColors.statusColor(report.status),
                      textColor: ReportStatusColors.statusTextColor(report.status),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const Divider(height: 32),
          
          // Details section
          const Text(
            'Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailItem('Description', report.description),
          _buildDetailItem('Status', StatusFormatter.formatReportStatus(report.status)),
          _buildDetailItem('Created', DateFormatter.formatEmissionDate(report.emissionDate)),
          const SizedBox(height: 24),
          
          // Actions section
          const Text(
            'Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 12),
          _buildActionItem('1. Review report details'),
          _buildActionItem('2. Update status if needed'),
          _buildActionItem('3. Contact support for assistance'),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.darkBlue,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.mediumGray,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          Expanded(
            child: Text(
              action,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.mediumGray,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

