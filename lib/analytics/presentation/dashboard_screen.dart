import 'package:flutter/material.dart';
import 'package:mobile_iot/analytics/presentation/water_supply_request_creation_screen.dart';
import 'package:mobile_iot/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:mobile_iot/analytics/presentation/report_creation_screen.dart';
import 'package:mobile_iot/shared/widgets/app_logo.dart';
import '../../monitoring/domain/entities/event.dart';
import '../../profiles/infrastructure/service/resident_api_service.dart';
import '../../shared/helpers/secure_storage_service.dart';
import '../../shared/widgets/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/monitoring/presentation/bloc/tank_events/tank_events_bloc.dart';
import 'package:mobile_iot/monitoring/presentation/bloc/tank_events/tank_events_state.dart';
import 'package:mobile_iot/monitoring/presentation/bloc/tank_events/tank_events_event.dart';
import 'package:mobile_iot/analytics/domain/logic/get_ph_from_status.dart';
import 'package:mobile_iot/shared/widgets/circular_progress_painter.dart';
import 'package:mobile_iot/analytics/domain/entities/water_reading.dart';
import '../../monitoring/application/device_use_case.dart';
import '../../profiles/application/resident_use_case.dart';
import '../../profiles/infrastructure/repositories/resident_repository_impl.dart';
import '../../monitoring/infrastructure/repositories/device_repository_impl.dart';
import '../../monitoring/infrastructure/service/device_api_service.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/session_expired_screen.dart';
import '../../../main.dart';
import 'package:mobile_iot/monitoring/presentation/widgets/app_loading_state.dart';
import 'package:mobile_iot/monitoring/domain/logic/get_event_status_color.dart';
import 'package:mobile_iot/analytics/domain/logic/percentage_formatter.dart';
import 'package:mobile_iot/analytics/domain/logic/water_status_utils.dart';
import 'package:mobile_iot/monitoring/domain/logic/event_utils.dart';

/// A screen that displays water tank analytics and monitoring dashboard for the authenticated user.
///
/// The screen automatically handles:
/// - Loading states while fetching tank events data
/// - Error states with retry functionality
/// - Session expiration and automatic logout
/// - Device detection and event retrieval
/// - Water percentage calculations and animations
/// - Water supply request creation and history viewing
///
class DashboardScreen extends StatefulWidget {
  /// Creates a dashboard screen.
  ///
  /// The [key] parameter is optional and is passed to the superclass.
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

/// The state class for the DashboardScreen widget.
///
/// This class manages the animation controller for the water level indicator
/// and maintains the water history data for display.
class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  /// Controller for the water level animation.
  late AnimationController _animationController;

  /// Animation for the circular progress indicator.
  late Animation<double> _animation;

  // List of tanks
  List<Map<String, dynamic>> tanks = [];
  
  /// List of subscription data for the resident.
  List<Map<String, dynamic>> subscriptions = [];

  /// List of all events from all tanks for the dashboard
  List<Event> _allDashboardEvents = [];

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for water level indicator
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Initialize animation with default values (will be updated dynamically)
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0, // Will be set dynamically based on water percentage
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start the initial animation
    _animationController.forward();
    
    // Load subscriptions when the widget initializes
    _loadSubscriptions();
  }

  @override
  void dispose() {
    // Clean up animation controller to prevent memory leaks
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TankEventsBloc>(
      create: (context) => TankEventsBloc(
        deviceUseCase: DeviceUseCase(DeviceRepositoryImpl(DeviceApiService())),
        secureStorage: SecureStorageService(),
        residentApiService: ResidentApiService(),
      )..add(const FetchTankEventsEvent()),
      child: BlocConsumer<TankEventsBloc, TankEventsState>(
        listener: (context, state) {
          if (state is TankEventsSessionExpiredState) {
            Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
          }
        },
        builder: (context, state) {
          if (state is TankEventsSessionExpiredState) {
            return SessionExpiredScreen(
              onLoginAgain: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              },
            );
          }
          switch (state.runtimeType) {
            case TankEventsLoadingState:
              return const Scaffold(
                backgroundColor: AppColors.lightGray,
                body: AppLoadingState(),
              );
            case TankEventsErrorState:
              return Center(child: Text('${AppLocalizations.of(context)!.error}: ${(state as TankEventsErrorState).message}'));
            case TankEventsLoadedState:
              // Wait until subscriptions are loaded
              if (subscriptions.isEmpty) {
                return const Scaffold(
                  backgroundColor: AppColors.lightGray,
                  body: AppLoadingState(),
                );
              }
              final events = _allDashboardEvents.isNotEmpty ? _allDashboardEvents : (state as TankEventsLoadedState).events;
              final loc = AppLocalizations.of(context)!;
              // Mapping: deviceId -> most recent event
              final latestEventsByTank = getLatestEventsByTank(events);
              latestEventsByTank.forEach((k, v) => print('  Tank $k: status=${v.qualityValue}, level=${v.levelValue}'));
              // For each tank (subscription), find its most recent event or set Without Water
              List<double> percentages = [];
              List<String> statuses = [];
              tanks = subscriptions.asMap().entries.map((entry) {
                final index = entry.key;
                final subscription = entry.value;
                final tankNumber = index + 1;
                final waterTankSize = (subscription['waterTankSize'] as num).toInt();
                final deviceId = subscription['deviceId'].toString();
                final event = latestEventsByTank[deviceId];
                String status;
                if (event != null) {
                  status = event.qualityValue;
                  final percent = double.tryParse(event.levelValue) ?? 0.0;
                  percentages.add(percent);
                } else {
                  status = loc.withoutWater;
                }
                statuses.add(status);
                return {
                  'reading': WaterReading(
                    time: '',
                    quantity: '${waterTankSize}L',
                    type: '${AppLocalizations.of(context)!.tank} $tankNumber',
                  ),
                  'deviceId': deviceId,
                };
              }).toList();
              final avgPercentage = average(percentages);
              final tanksWithoutWater = statuses.where((s) => s == loc.withoutWater).length;
              final realStatuses = statuses.where((s) => s != loc.withoutWater).toList();
              final worstStatus = realStatuses.isNotEmpty
                  ? getWorstStatus(realStatuses, loc)
                  : loc.withoutWater;
              final phLevel = getPhFromStatus(context, worstStatus);
              final waterQuantity = subscriptions.length;

              // Animación
              _animation = Tween<double>(
                begin: 0.0,
                end: avgPercentage / 100,
              ).animate(CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOut,
              ));
              _animationController.forward(from: 0.0);
              return Scaffold(
                backgroundColor: AppColors.lightGray,
                body: SafeArea(
                  child: Column(
                    children: [
                      _buildHeader(),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async => context.read<TankEventsBloc>().add(const RefreshTankEventsEvent()),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildCircularIndicator(avgPercentage),
                                const SizedBox(height: 24),
                                _buildDateSection(),
                                const SizedBox(height: 24),
                                _buildMetricsCard(
                                  status: worstStatus,
                                  waterQuantity: waterQuantity.toString(),
                                  phLevel: phLevel,
                                  tanksWithoutWater: tanksWithoutWater,
                                ),
                                const SizedBox(height: 32),
                                _buildRecentActivitySection(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: AppBottomNavigationBar(
                  currentIndex: 1, // Dashboard tab is active
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
                  tooltip: AppLocalizations.of(context)!.createReport,
                ),
              );
            default:
              return const Scaffold(
                backgroundColor: AppColors.lightGray,
                body: AppLoadingState(),
              ); // Fallback to loading state
          }
        },
      ),
    );
  }

  /// Builds the dashboard header with the app logo and refresh button.
  ///
  /// This method creates a header section that displays
  /// the application logo with a refresh button for manual
  /// data updates and a language selector.
  ///
  /// Returns a container widget with the app logo, refresh button, and language dropdown.
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AppLogo(fontSize: 24),
          Row(
            children: [
              // Refresh button
              BlocBuilder<TankEventsBloc, TankEventsState>(
                builder: (context, state) {
                  return IconButton(
                    onPressed: state is TankEventsLoadingState ? null : () => context.read<TankEventsBloc>().add(const RefreshTankEventsEvent()),
                    icon: state is TankEventsLoadingState
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                            ),
                          )
                        : const Icon(Icons.refresh, color: AppColors.primaryBlue),
                    tooltip: AppLocalizations.of(context)!.refresh,
                  );
                },
              ),
              _buildLanguageDropdown(),
            ],
          ),
        ],
      ),
    );
  }
///
/// Widget to change the app language.
///
  Widget _buildLanguageDropdown() {
    Locale currentLocale = Localizations.localeOf(context);
    return DropdownButton<Locale>(
      value: currentLocale.languageCode == 'es' ? const Locale('es') : const Locale('en'),
      icon: const Icon(Icons.language, color: Colors.blue),
      underline: Container(height: 0),
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          AquaConectaAppState.changeLocale(newLocale);
        }
      },
      items: [
        DropdownMenuItem(
          value: const Locale('en'),
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: const Locale('es'),
          child: Text('Español'),
        ),
      ],
    );
  }

  /// Builds the circular indicator for water level.
  /// 
  /// This method creates a circular progress indicator that displays
  /// the current water level percentage with animated progress.
  /// The indicator uses a custom painter for the circular progress
  /// and displays the percentage value in the center.
  /// 
  /// Parameters:
  /// - [currentPercentage]: The current water level percentage to display
  /// 
  /// Returns a centered widget with the circular water level indicator.
  Widget _buildCircularIndicator(double currentPercentage) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: CustomPaint(
          painter: CircularProgressPainter(
            progress: currentPercentage / 100, // Assuming 1000L is 100%
            strokeWidth: 12.0,
            backgroundColor: AppColors.customGray,
            progressColor: AppColors.primaryBlue,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    formatDashboardPercentage(currentPercentage),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.water,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.darkBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the date section displaying the current day.
  /// 
  /// This method creates a centered text widget that displays
  /// the current day label with consistent styling.
  /// Currently shows "Today" as a static label.
  /// 
  /// Returns a centered text widget with the date label.
  Widget _buildDateSection() {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.today,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkBlue,
        ),
      ),
    );
  }

  /// Builds the metrics card with status, quantity, and pH information.
  /// 
  /// This method creates a card widget that displays key water metrics:
  /// - Water status (normal, alert, critical) with color-coded indicators
  /// - Current water quantity
  /// - pH level
  /// - Water supply request button
  /// - Request history button
  /// 
  /// Parameters:
  /// - [status]: The current water status string
  /// - [waterQuantity]: The current water quantity value
  /// - [phLevel]: The current pH level value
  /// 
  /// Returns a card widget containing the metrics display and action buttons.
  Widget _buildMetricsCard({
    required String status,
    required String waterQuantity,
    required double phLevel,
    required int tanksWithoutWater,
  }) {
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
                title: getLocalizedWaterStatus(context, status),
                subtitle: AppLocalizations.of(context)!.status,
                color: (status.trim().toLowerCase().contains('without water') ||
                        status.trim().toLowerCase().contains(AppLocalizations.of(context)!.withoutWater.toLowerCase()))
                    ? AppColors.mediumGray
                    : getReportStatusTextColor(getStatusFromQuality(context, status)),
                icon: Icons.check_circle,
              ),
              _buildVerticalDivider(),
              _buildMetricItem(
                title: waterQuantity,
                subtitle: AppLocalizations.of(context)!.quantity,
                color: AppColors.primaryBlue,
                icon: Icons.water_drop,
              ),
              _buildVerticalDivider(),
              _buildMetricItem(
                title: phLevel.toString(),
                subtitle: AppLocalizations.of(context)!.ph,
                color: AppColors.darkBlue,
                icon: Icons.science,
              ),
            ],
          ),
          if (tanksWithoutWater > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.warning, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tanksWithoutWater == 1
                      ? AppLocalizations.of(context)!.withoutWater
                      : '${AppLocalizations.of(context)!.withoutWater}: $tanksWithoutWater',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final liters = await WaterSupplyRequestCreationScreen.show(context);
                if (liters != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.requestedLitersOfWater(liters)),
                      backgroundColor: AppColors.green,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context)!.requestWater),
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
              label: Text(AppLocalizations.of(context)!.viewRequestHistory, style: const TextStyle(color: AppColors.primaryBlue)),
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

  /// Builds a metric item for the metrics card.
  /// 
  /// This method creates a column widget that displays a single metric
  /// with an icon, title, and subtitle. Used for displaying status,
  /// quantity, and pH information in the metrics card.
  /// 
  /// Parameters:
  /// - [title]: The main value to display 
  /// - [subtitle]: The label for the metric 
  /// - [color]: The color for the icon and title text
  /// - [icon]: The icon to display above the title
  /// 
  /// Returns a column widget with the metric display.
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
            color: AppColors.darkBlue,
          ),
        ),
      ],
    );
  }

  /// Builds a vertical divider for the metrics card.
  /// 
  /// This method creates a thin vertical line that separates
  /// the different metric items in the metrics card for better
  /// visual organization.
  /// 
  /// Returns a container widget with a vertical divider line.
  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.darkBlue.withOpacity(0.3),
    );
  }

  ///
  /// This method creates a section that displays recent water activity
  /// with a title and a card containing the water history items.
  /// The section shows the latest water reading from the tank events.
  /// 
  /// Returns a column widget with the history section title and content.
  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.recentActivity,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 16),
        ...tanks.map((tankData) =>
          Container(
            margin: const EdgeInsets.only(bottom: 12),
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
            child: _buildHistoryItem(tankData['reading'], tankData['deviceId']),
          )
        ).toList(),
      ],
    );
  }

  /// Builds an individual history item for the recent activity section.
  /// 
  /// This method creates a tappable row widget that displays a single
  /// water reading from the history. Each item shows a colored dot,
  /// the reading type, and the quantity value.
  /// 
  /// Parameters:
  /// - [reading]: The water reading entity to display
  /// 
  /// Returns a gesture detector widget with the history item display.
  Widget _buildHistoryItem(WaterReading reading, String deviceId) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pushReplacementNamed(
          context,
          '/history',
          arguments: {'deviceId': deviceId},
        );
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      fontSize: 14,
                      color: AppColors.darkBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Loads subscriptions for the current resident.
  /// 
  /// This method fetches subscription data from the API and updates
  /// the subscriptions list with the water tank information.
  /// 
  /// Returns a Future that completes when the subscriptions are loaded.
  Future<void> _loadSubscriptions() async {
    try {
      final secureStorage = SecureStorageService();
      final token = await secureStorage.getToken();
      if (token == null) return;

      final residentUseCase = ResidentUseCase(ResidentRepositoryImpl(ResidentApiService()));
      final resident = await residentUseCase.getProfile(token);
      if (resident == null) return;

      final residentApiService = ResidentApiService();
      final subscriptionsData = await residentApiService.getSubscriptionsByResidentId(token, resident.id);

      // Get events for all deviceIds
      final deviceApiService = DeviceApiService();
      List<Event> allEvents = [];
      for (final sub in subscriptionsData) {
        final deviceId = sub['deviceId'];
        if (deviceId != null) {
          try {
            final events = await deviceApiService.getEventsByDeviceId(token, deviceId);
            allEvents.addAll(events);
          } catch (e) {
            print('Error fetching events for deviceId $deviceId: $e');
          }
        }
      }

      setState(() {
        subscriptions = subscriptionsData;
        // Save the events in the state to use them in the builder
        _allDashboardEvents = allEvents;
      });
    } catch (e) {
      // Handle error silently or log it
      print('Error loading subscriptions: $e');
    }
  }
}