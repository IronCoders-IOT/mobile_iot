import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:mobile_iot/analytics//presentation/water_request/water_request_screen.dart';
import 'package:mobile_iot/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:mobile_iot/analytics/presentation/create_report/create_report_screen.dart';
import 'package:mobile_iot/analytics/domain/entities/sensor.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  // Datos simulados del dashboard
  final double currentPercentage = 70.0;
  final String waterStatus = "Safe";
  final String waterQuantity = "700L";
  final double phLevel = 7.0;
  
  final List<WaterReading> waterHistory = [
    WaterReading(time: "15:00", quantity: "700L", type: "Water")
  ];

  // Sensor list state
  List<Sensor> sensors = [];
  bool _isLoadingSensors = true;
  String? _sensorError;
  final TextEditingController _sensorSearchController = TextEditingController();
  String _sensorSearchQuery = '';

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
/*
  Future<void> _fetchSensors() async {
    setState(() {
      _isLoadingSensors = true;
      _sensorError = null;
    });
    try {
      final storage = SecureStorageService();
      final token = await storage.getToken();
      if (token == null) throw Exception('No authentication token found');
      final residentJson = await ResidentApiService().getResident(token);
      if (residentJson == null || residentJson['id'] == null) throw Exception('Resident not found');
      final residentId = residentJson['id'] as int;
      final sensorUseCase = SensorUseCase(SensorRepositoryImpl(SensorApiService()));
      final fetchedSensors = await sensorUseCase.getSensor(token, residentId);
      setState(() {
        sensors = fetchedSensors;
        _isLoadingSensors = false;
      });
    } catch (e) {
      setState(() {
        _sensorError = e.toString();
        _isLoadingSensors = false;
      });
    }
  }

  List<Sensor> get filteredSensors {
    if (_sensorSearchQuery.isEmpty) {
      return sensors;
    }
    return sensors.where((sensor) {
      final typeLower = sensor.type.toLowerCase();
      final statusLower = sensor.status.toLowerCase();
      final searchLower = _sensorSearchQuery.toLowerCase();
      return typeLower.contains(searchLower) || statusLower.contains(searchLower);
    }).toList();
  }
*/
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
    _sensorSearchController.dispose();
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
                    
                    // --- Sensor Section ---
                    /*
                    _isLoadingSensors
                        ? const Center(child: CircularProgressIndicator())
                        : _sensorError != null
                            ? Center(
                                child: Column(
                                  children: [
                                    Text(_sensorError!, style: const TextStyle(color: Colors.red)),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: _fetchSensors,
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                            : sensors.isEmpty
                                ? Column(
                                    children: [
                                      const Text('No sensors found.'),
                                      const SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(context, '/reports');
                                        },
                                        child: const Text('View All Sensors'),
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildSensorCard(sensors.first),
                                      const SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(context, '/reports');
                                        },
                                        child: const Text('View All Sensors'),
                                      ),
                                    ],
                                  ),
                    
                    const SizedBox(height: 32),
                    */
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
            MaterialPageRoute(builder: (context) => const CreateReportScreen()),
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
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Aqua',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                TextSpan(
                  text: 'Conecta',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
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
                final liters = await WaterRequestScreen.show(context);
                if (liters != null) {
                  // TODO: Handle the water request
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Requested $liters liters of analytics'),
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
            fontSize: 18,
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
      height: 40,
      width: 1,
      color: AppColors.lightGray,
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Water Tanks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...waterHistory.map((reading) => _buildHistoryItem(reading)).toList(),
      ],
    );
  }

  Widget _buildHistoryItem(WaterReading reading) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/history');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 1),
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
                Icons.water_drop,
                color: AppColors.primaryBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reading.type,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
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
            Text(
              reading.quantity,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorCard(Sensor sensor) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
      child: InkWell(
        onTap: () => _showSensorDetails(sensor),
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
              Icon(Icons.sensors, color: AppColors.primaryBlue, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sensor.type,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Description: ${sensor.status}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.mediumGray,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.mediumGray.withOpacity(0.5), size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSensorDetailsModal(Sensor sensor) {
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
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.sensors,
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
                        sensor.type,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue,
                        ),
                      ),
                      Text(
                        'Sensor ID: ${sensor.id}',
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
                  Text(
                    'Type: ${sensor.type}\nDescription: ${sensor.status}\nResident ID: ${sensor.residentId}',
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

// Modelo para las lecturas de agua
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

// Painter personalizado para el círculo de progreso
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

    // Dibujar círculo de fondo
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Dibujar progreso
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Empezar desde arriba
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

// Colores de la app (reutilizando los del login)
class AppColors {
  static const Color primaryBlue = Color(0xFF3498DB);
  static const Color darkBlue = Color(0xFF2C3E50);
  static const Color lightGray = Color(0xFFF8F9FA);
  static const Color mediumGray = Color(0xFF6C757D);
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF28A745);
}