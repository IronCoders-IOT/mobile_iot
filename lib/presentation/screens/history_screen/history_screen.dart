import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<HistoryScreen> {
  // Lista de reportes simulados
  final List<SensorHistory> reports = [
    SensorHistory(
      id: 1,
      event: "Quality",
      water_quality: "ph: 7.2",
      status: ReportStatus.normal,
      water_level: "High"
    ),
    SensorHistory(
      id: 2,
      event: "Pressure",
      water_quality: "ph: 6.8",
      status: ReportStatus.alert,
      water_level: "Medium"
    ),
    SensorHistory(
      id: 3,
      event: "Water Level",
      water_quality: "ph: 5.5",
      status: ReportStatus.critical,
      water_level: "Low"
    ),
  ];

  // Controller for search text
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
              child: _buildReportsList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
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

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: reportsToShow.length,
      itemBuilder: (context, index) {
        final report = reportsToShow[index];
        return _buildReportItem(report, index);
      },
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

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.description, 0, true), // Reports - activo
          _buildNavItem(context, Icons.home, 1, false), // Home
          _buildNavItem(context, Icons.person, 2, false), // Profile
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, int index, bool isActive) {
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            // Ya estamos en Reports
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/dashboard');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          color: isActive ? AppColors.white : AppColors.white.withOpacity(0.6),
          size: 28,
        ),
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
        return const Color(0xFFE8F5E9); // Light blue
      case ReportStatus.alert:
        return const Color(0xFFFFF8E1); // Light yellow
      case ReportStatus.critical:
        return const Color(0xFFFFEBEE); // Light red
    }
  }

  Color get textColor {
    switch (this) {
      case ReportStatus.normal:
        return const Color(0xFF4CAF50); // Blue
      case ReportStatus.alert:
        return const Color(0xFFFFC107); // Amber (Yellow)
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