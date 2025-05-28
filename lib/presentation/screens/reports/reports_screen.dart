import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // Lista de reportes simulados
  final List<SensorReport> reports = [
    SensorReport(
      id: 1,
      title: "Sensor failure",
      description: "The sensor started to fail at 8 am, causing inaccurate readings and",
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    SensorReport(
      id: 2,
      title: "Sensor failure",
      description: "The sensor started to fail at 8 am, causing inaccurate readings and",
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: false,
    ),
    SensorReport(
      id: 3,
      title: "Sensor failure",
      description: "The sensor started to fail at 8 am, causing inaccurate readings and",
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      isRead: false,
    ),
    SensorReport(
      id: 4,
      title: "Sensor failure",
      description: "The sensor started to fail at 8 am, causing inaccurate readings and",
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      isRead: false,
    ),
    SensorReport(
      id: 5,
      title: "Sensor failure",
      description: "The sensor started to fail at 8 am, causing inaccurate readings and",
      timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      isRead: false,
    ),
    SensorReport(
      id: 6,
      title: "Sensor failure",
      description: "The sensor started to fail at 8 am, causing inaccurate readings and",
      timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      isRead: false,
    ),
    SensorReport(
      id: 7,
      title: "Sensor failure",
      description: "The sensor started to fail at 8 am, causing inaccurate readings and",
      timestamp: DateTime.now().subtract(const Duration(hours: 14)),
      isRead: false,
    ),
  ];

  void _markAsRead(int reportId) {
    setState(() {
      final reportIndex = reports.indexWhere((report) => report.id == reportId);
      if (reportIndex != -1) {
        reports[reportIndex].isRead = true;
      }
    });
  }

  void _showReportDetails(SensorReport report) {
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
            'REPORTS',
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

  Widget _buildReportsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return _buildReportItem(report, index);
      },
    );
  }

  Widget _buildReportItem(SensorReport report, int index) {
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
                // Icono de warning
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    color: Colors.orange[600],
                    size: 22,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Contenido del reporte
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
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
                          if (!report.isRead) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ],
                      ),
                      
                      const SizedBox(height: 6),
                      
                      // Descripción
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
                      
                      // Timestamp
                      Text(
                        _formatTimestamp(report.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mediumGray.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Icono de flecha
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

  Widget _buildReportDetailsModal(SensorReport report) {
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
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    color: Colors.orange[600],
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
                        _formatTimestamp(report.timestamp),
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
                    'Report Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'The sensor started to fail at 8 am, causing inaccurate readings and potentially affecting water quality monitoring. This issue requires immediate attention to ensure proper system functionality.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.mediumGray,
                      height: 1.5,
                    ),
                  ),
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
                  _buildActionItem('1. Check sensor connections'),
                  _buildActionItem('2. Verify power supply'),
                  _buildActionItem('3. Contact technical support if issue persists'),
                  
                  const SizedBox(height: 24),
                  
                  // Botón de acción
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Technical support contacted'),
                            backgroundColor: AppColors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Contact Support',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
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
class SensorReport {
  final int id;
  final String title;
  final String description;
  final DateTime timestamp;
  bool isRead;

  SensorReport({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    this.isRead = false,
  });
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