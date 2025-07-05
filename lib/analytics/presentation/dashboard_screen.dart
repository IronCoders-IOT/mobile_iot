import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:mobile_iot/analytics/presentation/water_supply_request_creation_screen.dart';
import 'package:mobile_iot/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:mobile_iot/analytics/presentation/report_creation_screen.dart';
import 'package:mobile_iot/analytics/domain/entities/sensor.dart';

import 'package:mobile_iot/shared/widgets/app_logo.dart';

import '../../shared/widgets/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  final double currentPercentage = 70.0;
  final String waterStatus = "Safe";
  final String waterQuantity = "700L";
  final double phLevel = 7.0;
  
  final List<WaterReading> waterHistory = [
    WaterReading(time: "15:00", quantity: "700L", type: "Water")
  ];


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: currentPercentage / 100,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    // Iniciar animación
    _animationController.forward();
   // _fetchSensors();
  }
  void _showSensorDetails(Sensor sensor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSensorDetailsModal(sensor),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Column(
          children: [
            // Header con logo
            _buildHeader(),
            
            // Contenido principal
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Indicador circular
                    _buildCircularIndicator(),
                    
                    const SizedBox(height: 24),
                    
                    // Fecha actual
                    _buildDateSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Tarjeta de métricas
                    _buildMetricsCard(),
                    
                    const SizedBox(height: 32),
                    // Sección de historial
                    _buildHistorySection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/reports');
              break;
            case 1:
              // Already on dashboard
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReportCreationScreen()),
          );
        },
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Create Report',
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppLogo(fontSize: 24),
        ],
      ),
    );
  }

  Widget _buildCircularIndicator() {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: CircularProgressPainter(
                progress: _animation.value,
                strokeWidth: 12.0,
                backgroundColor: AppColors.lightGray,
                progressColor: AppColors.primaryBlue,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(_animation.value * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const Text(
                      'Percentage',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return const Center(
      child: Text(
        'Today',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkBlue,
        ),
      ),
    );
  }

  Widget _buildMetricsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricItem(
                title: waterStatus,
                subtitle: 'Status',
                color: AppColors.green,
                icon: Icons.check_circle,
              ),
              _buildVerticalDivider(),
              _buildMetricItem(
                title: waterQuantity,
                subtitle: 'Quantity',
                color: AppColors.primaryBlue,
                icon: Icons.water_drop,
              ),
              _buildVerticalDivider(),
              _buildMetricItem(
                title: phLevel.toString(),
                subtitle: 'pH',
                color: AppColors.darkBlue,
                icon: Icons.science,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final liters = await WaterSupplyRequestCreationScreen.show(context);
                if (liters != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Requested $liters liters of water'),
                      backgroundColor: AppColors.green,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Request Water'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/request-history');
              },
              icon: const Icon(Icons.history, color: AppColors.primaryBlue),
              label: const Text('View Request History', style: TextStyle(color: AppColors.primaryBlue)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryBlue),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.mediumGray,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.mediumGray.withOpacity(0.3),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: waterHistory.map((reading) => _buildHistoryItem(reading)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(WaterReading reading) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pushReplacementNamed(context, '/history');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reading.type,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  Text(
                    reading.quantity,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mediumGray,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              reading.time,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.mediumGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorDetailsModal(Sensor sensor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
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
                    Icons.sensors,
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
                        'Sensor ${sensor.id}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue,
                        ),
                      ),
                      Text(
                        'Status: Active',
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
                    'Sensor Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailItem('Sensor ID', sensor.id.toString()),
                  _buildDetailItem('Location', 'Tank ${sensor.id}'),
                  _buildDetailItem('Type', 'Water Quality Sensor'),
                  const SizedBox(height: 24),
                  const Text(
                    'Actions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActionItem('1. View sensor data'),
                  _buildActionItem('2. Check sensor status'),
                  _buildActionItem('3. Contact support if needed'),
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

class WaterReading {
  final String time;
  final String quantity;
  final String type;

  WaterReading({
    required this.time,
    required this.quantity,
    required this.type,
  });
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      2 * math.pi * progress, // Progress arc
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.strokeWidth != strokeWidth ||
           oldDelegate.backgroundColor != backgroundColor ||
           oldDelegate.progressColor != progressColor;
  }
}

