import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/management/infrastructure/data_sources/resident_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/data_sources/report_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/repositories/report_repository_impl.dart';
import 'package:mobile_iot/analytics/application/report_use_case.dart';
import 'package:mobile_iot/analytics/domain/entities/report.dart';
import 'package:mobile_iot/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:mobile_iot/analytics/presentation/create_report/create_report_screen.dart';
import 'package:intl/intl.dart';

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
      builder: (context) => _buildReportDetailsModal(report),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearchBar(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? _buildErrorWidget()
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
            MaterialPageRoute(builder: (context) => const CreateReportScreen()),
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

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.mediumGray.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading reports',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.mediumGray,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? 'Unknown error occurred',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.mediumGray.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _fetchReports,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Botón back
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.darkBlue,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Título
          const Text(
            'REPORTS',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
              letterSpacing: 1.2,
            ),
          ),
          
          const Spacer(),
          
          // Botón de refresh
          GestureDetector(
            onTap: _refreshReports,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.refresh,
                color: AppColors.primaryBlue,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search reports...',
          prefixIcon: const Icon(Icons.search, color: AppColors.mediumGray),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primaryBlue.withOpacity(0.2),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primaryBlue,
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildReportsList() {
    final reportsToShow = filteredReports;
    if (reportsToShow.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: AppColors.mediumGray.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No reports found',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.mediumGray,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pull down to refresh or create a new report',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.mediumGray.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 0,
        child: InkWell(
          onTap: () => _showReportDetails(report),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryBlue.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.description,
                    color: AppColors.primaryBlue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            report.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor(report.status),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              formatStatus(report.status),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: statusTextColor(report.status),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        report.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.mediumGray,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Emission: ${formatEmissionDate(report.emissionDate)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mediumGray.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.mediumGray.withOpacity(0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportDetailsModal(Report report) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.mediumGray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.description,
                    color: AppColors.primaryBlue,
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
                      Text(
                        'Report ID: ${report.id}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.mediumGray,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Report Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Title: ${report.title}\nDescription: ${report.description}\nStatus: ${formatStatus(report.status)}\nEmission Date: ${report.emissionDate}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.mediumGray,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Colores de la app (reutilizando)
class AppColors {
  static const Color primaryBlue = Color(0xFF3498DB);
  static const Color darkBlue = Color(0xFF2C3E50);
  static const Color lightGray = Color(0xFFF8F9FA);
  static const Color mediumGray = Color(0xFF6C757D);
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF28A745);
}