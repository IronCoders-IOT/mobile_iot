import 'package:flutter/material.dart';
import 'package:mobile_iot/analytics/presentation/water_supply_request_creation_screen.dart';
import 'package:mobile_iot/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:mobile_iot/analytics/presentation/report_creation_screen.dart';
import 'package:mobile_iot/shared/widgets/app_logo.dart';
import '../../profiles/infrastructure/service/resident_api_service.dart';
import '../../shared/helpers/secure_storage_service.dart';
import '../../shared/widgets/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/analytics/presentation/bloc/tank_events/bloc/tank_events_bloc.dart';
import 'package:mobile_iot/analytics/presentation/bloc/tank_events/bloc/tank_events_state.dart';
import 'package:mobile_iot/analytics/presentation/bloc/tank_events/bloc/tank_events_event.dart';
import 'package:mobile_iot/analytics/domain/logic/get_event_status_color.dart';
import 'package:mobile_iot/analytics/domain/logic/get_ph_from_status.dart';
import 'package:mobile_iot/analytics/domain/logic/calculate_water_percentage.dart';
import 'package:mobile_iot/shared/widgets/circular_progress_painter.dart';
import 'package:mobile_iot/analytics/domain/entities/water_reading.dart';
import '../application/device_use_case.dart';
import '../application/event_use_case.dart';
import '../infrastructure/repositories/device_repository_impl.dart';
import '../infrastructure/repositories/event_repository_impl.dart';
import '../infrastructure/service/device_api_service.dart';
import '../infrastructure/service/event_api_service.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import '../../../main.dart';

/// A screen that displays water tank analytics and monitoring dashboard for the authenticated user.
/// 
/// This screen uses the BLoC pattern for state management and provides the following features:
/// - Real-time water level monitoring with circular progress indicator
/// - Current water status, quantity, and pH level display
/// - Water supply request functionality
/// - Recent activity tracking
/// - Navigation to other app sections via bottom navigation
/// - Quick access to report creation via floating action button
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
  
  /// List of water readings for the history section.
  List<WaterReading> waterHistory = [];

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
        eventUseCase: EventUseCase(EventRepositoryImpl(EventApiService())),
        secureStorage: SecureStorageService(),
        residentApiService: ResidentApiService(),
      )..add(FetchTankEventsEvent()),
      child: BlocBuilder<TankEventsBloc, TankEventsState>(
        builder: (context, state) {
          // Handle loading state - show loading indicator
          if (state is TankEventsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } 
          // Handle error state - show error message
          else if (state is TankEventsErrorState) {
            return Center(child: Text('${AppLocalizations.of(context)!.error}: ${state.message}'));
          } 
          // Handle loaded state with events - show dashboard content
          else if (state is TankEventsLoadedState && state.events.isNotEmpty) {
            // Extract data from the latest event for display
            final latestEvent = state.events.last;
            final status = getStatusFromQuality(latestEvent.qualityValue);
            final waterQuantity = latestEvent.levelValue;
            final phLevel = getPhFromStatus(status);
            final currentPercentage = calculateWaterPercentage(state.events);
            
            // Update water history with the latest event for display
            waterHistory = [
              WaterReading(time: '', quantity: waterQuantity, type: 'Water'),
            ];
            
            // Update animation to reflect the new water percentage
            _animation = Tween<double>(
              begin: 0.0,
              end: currentPercentage / 1000, // Assuming 1000L is 100%
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
                    // Header with app logo
                    _buildHeader(),
                    
                    // Main content area with scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Circular water level indicator
                            _buildCircularIndicator(currentPercentage),
                            
                            const SizedBox(height: 24),
                            
                            // Current date section
                            _buildDateSection(),
                            
                            const SizedBox(height: 24),
                            
                            // Metrics card with status, quantity, and pH
                            _buildMetricsCard(
                              status: status,
                              waterQuantity: waterQuantity,
                              phLevel: phLevel,
                            ),
                            
                            const SizedBox(height: 32),
                            // Recent activity history section
                            _buildHistorySection(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom navigation bar for app-wide navigation
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
              // Floating action button for quick report creation
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
          } 
          // Handle empty state - show no events message
          else {
            return Center(child: Text(AppLocalizations.of(context)!.noEventsFound));
          }
        },
      ),
    );
  }

  /// Builds the dashboard header with the app logo.
  /// 
  /// This method creates a centered header section that displays
  /// the application logo with consistent styling and padding.
  /// 
  /// Returns a container widget with the app logo centered horizontally.
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AppLogo(fontSize: 24),
          _buildLanguageDropdown(),
        ],
      ),
    );
  }

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
            progress: currentPercentage / 1000, // Assuming 1000L is 100%
            strokeWidth: 12.0,
            backgroundColor: AppColors.lightGray,
            progressColor: AppColors.primaryBlue,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${currentPercentage.toStringAsFixed(2)} %',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.water,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.mediumGray,
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
                title: status,
                subtitle: AppLocalizations.of(context)!.status,
                color: AppColors.green,
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
            color: AppColors.mediumGray,
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
      color: AppColors.mediumGray.withOpacity(0.3),
    );
  }

  /// Builds the recent activity history section.
  /// 
  /// This method creates a section that displays recent water activity
  /// with a title and a card containing the water history items.
  /// The section shows the latest water reading from the tank events.
  /// 
  /// Returns a column widget with the history section title and content.
  Widget _buildHistorySection() {
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
          ],
        ),
      ),
    );
  }
}

