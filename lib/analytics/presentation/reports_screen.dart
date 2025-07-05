import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/profiles/infrastructure/service/resident_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/service/report_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/repositories/report_repository_impl.dart';
import 'package:mobile_iot/analytics/application/report_use_case.dart';
import 'package:mobile_iot/analytics/domain/entities/report.dart';
import 'package:mobile_iot/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:mobile_iot/analytics/presentation/report_creation_screen.dart';
import 'package:intl/intl.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_header.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_search_bar.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_empty_state.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_error_state.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_loading_state.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_list_card.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_status_badge.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_modal_bottom_sheet.dart';

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

  String formatStatus(String status) {
    // Convert IN_PROGRESS to IN PROGRESS, keep others as is, uppercase
    return status.replaceAll('_', ' ').toUpperCase();
  }

  Color statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'RECEIVED':
        return const Color(0xFFD6ECFF); // light blue background
      case 'IN_PROGRESS':
        return const Color(0xFFFFF6D6); // light yellow background
      case 'CLOSED':
        return const Color(0xFFD6FFE6); // light green background
      default:
        return AppColors.mediumGray.withOpacity(0.1);
    }
  }

  Color statusTextColor(String status) {
    switch (status.toUpperCase()) {
      case 'RECEIVED':
        return const Color(0xFF3498DB); // blue
      case 'IN_PROGRESS':
        return const Color(0xFFF4C542); // yellow
      case 'CLOSED':
        return const Color(0xFF28A745); // green
      default:
        return AppColors.mediumGray;
    }
  }

  String formatEmissionDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('MMMM d, yyyy, h:mm a').format(date);
    } catch (e) {
      return isoString;
    }
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
                text: formatStatus(report.status),
                backgroundColor: statusColor(report.status),
                textColor: statusTextColor(report.status),
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
            'Created: ${formatEmissionDate(report.emissionDate)}',
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
                  color: statusColor(report.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.description,
                  color: statusTextColor(report.status),
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
                      text: formatStatus(report.status),
                      backgroundColor: statusColor(report.status),
                      textColor: statusTextColor(report.status),
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
          _buildDetailItem('Status', formatStatus(report.status)),
          _buildDetailItem('Created', formatEmissionDate(report.emissionDate)),
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

