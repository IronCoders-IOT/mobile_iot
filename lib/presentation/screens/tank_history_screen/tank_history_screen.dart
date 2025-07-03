import 'package:flutter/material.dart';
import 'package:mobile_iot/core/services/secure_storage_service.dart';
import 'package:mobile_iot/infrastructure/data_sources/resident_api_service.dart';
import 'package:mobile_iot/infrastructure/data_sources/sensor_api_service.dart';
import 'package:mobile_iot/infrastructure/data_sources/event_api_service.dart';
import 'package:mobile_iot/infrastructure/repositories/sensor_repository_impl.dart';
import 'package:mobile_iot/infrastructure/repositories/event_repository_impl.dart';
import 'package:mobile_iot/application/use_cases/sensor_use_case.dart';
import 'package:mobile_iot/application/use_cases/event_use_case.dart';
import 'package:mobile_iot/domain/entities/event.dart';
import 'package:mobile_iot/domain/entities/sensor.dart';
import 'package:mobile_iot/presentation/widgets/app_bottom_navigation_bar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<HistoryScreen> {
  // API-driven data
  List<SensorHistory> reports = [];
  bool _isLoading = true;
  String? _error;

  // Controller for search text
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final storage = SecureStorageService();
      final token = await storage.getToken();
      if (token == null) throw Exception('No authentication token found');
      // Get resident
      final residentJson = await ResidentApiService().getResident(token);
      if (residentJson == null || residentJson['id'] == null) throw Exception('Resident not found');
      final residentId = residentJson['id'] as int;
      // Get sensors for resident
      final sensorUseCase = SensorUseCase(SensorRepositoryImpl(SensorApiService()));
      final sensors = await sensorUseCase.getSensor(token, residentId);
      if (sensors.isEmpty) throw Exception('No sensors found for resident');
      final sensorId = sensors.first.id;
      // Get events for sensor
      final eventUseCase = EventUseCase(EventRepositoryImpl(EventApiService()));
      final events = await eventUseCase.getAllEventsBySensorId(token, sensorId);
      // Map events to SensorHistory
      reports = events.asMap().entries.map((entry) {
        final e = entry.value;
        return SensorHistory(
          id: entry.key + 1, 
          event: e.eventType,
          water_quality: e.qualityValue,
          status: _statusFromQuality(e.qualityValue),
          water_level: e.levelValue,
        );
      }).toList();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // Determina el estado del reporte según la calidad del agua
  ReportStatus _statusFromQuality(String quality) {
    switch (quality.toLowerCase()) {
      case 'mala':
      case 'no potable':
        return ReportStatus.alert;
      case 'agua contaminada':
        return ReportStatus.critical;
      default:
        return ReportStatus.normal;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtered reports based on search query
  List<SensorHistory> get filteredReports {
    if (_searchQuery.isEmpty) {
      return reports;
    }
    return reports.where((report) {
      return report.event.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             report.water_quality.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             report.water_level.toLowerCase().contains(_searchQuery.toLowerCase());

    }).toList();
  }

  void _markAsRead(int reportId) {
    setState(() {
      final reportIndex = reports.indexWhere((report) => report.id == reportId);
      if (reportIndex != -1) {
        reports[reportIndex].isRead = true;
      }
    });
  }

  void _showReportDetails(SensorHistory report) {
    _markAsRead(report.id);
    
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
            // Header
            _buildHeader(context),
            
            // Search Bar
            _buildSearchBar(),
            
            // Lista de reportes
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _error!,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchHistory,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : _buildReportsList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 0, // or another index if this is not reports
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on reports/history
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
            'TANKS HISTORY',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
              letterSpacing: 1.2,
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
          hintText: 'Search events...',
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
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchHistory,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: reportsToShow.length,
        itemBuilder: (context, index) {
          final report = reportsToShow[index];
          return _buildReportItem(report, index);
        },
      ),
    );
  }

  Widget _buildReportItem(SensorHistory report, int index) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ID and Event
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID: ${report.id}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    Text(
                      report.event,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Water Quality and Level
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        report.water_quality,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.mediumGray,
                        ),
                      ),
                    ),
                    Text(
                      'Level: ${report.water_level}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Status
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: report.status.color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      report.status.displayName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: report.status.textColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportDetailsModal(SensorHistory report) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.mediumGray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header del modal
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: report.status.color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.water_drop,
                    color: report.status.textColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.event,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue,
                        ),
                      ),
                      Text(
                        'Water Level: ${report.water_level}',
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
          
          // Contenido del modal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailItem('Water Quality', report.water_quality),
                  _buildDetailItem('Status', report.status.displayName),
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Recommended Actions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActionItem('1. Monitor water quality levels'),
                  _buildActionItem('2. Check tank water level'),
                  _buildActionItem('3. Contact support if issues persist'),
                  
                  const SizedBox(height: 24),
                  

                ],
              ),
            ),
          ),
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

// Modelo para los reportes de sensores
class SensorHistory {
  final int id;
  final String event;
  final String water_quality;
  final ReportStatus status;
  final String water_level;
  bool isRead;

  SensorHistory({
    required this.id,
    required this.event,
    required this.water_quality,
    required this.status,
    required this.water_level,
    this.isRead = false,
  });
}

enum ReportStatus { normal, alert, critical }

extension ReportStatusExtension on ReportStatus {
  String get displayName {
    switch (this) {
      case ReportStatus.normal:
        return 'Normal';
      case ReportStatus.alert:
        return 'Alert';
      case ReportStatus.critical:
        return 'Critical';
    }
  }

  Color get color {
    switch (this) {
      case ReportStatus.normal:
        return const Color(0xFFE8F5E9); // Light green
      case ReportStatus.alert:
        return const Color(0xFFFFE0B2); // Light orange
      case ReportStatus.critical:
        return const Color(0xFFFFEBEE); // Light red
    }
  }

  Color get textColor {
    switch (this) {
      case ReportStatus.normal:
        return const Color(0xFF4CAF50); // Green
      case ReportStatus.alert:
        return const Color(0xFFFF9800); // Orange
      case ReportStatus.critical:
        return const Color(0xFFD32F2F); // Red
    }
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