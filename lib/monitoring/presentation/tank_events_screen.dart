import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/profiles/infrastructure/service/resident_api_service.dart';
import 'package:mobile_iot/monitoring/infrastructure/service/device_api_service.dart';
import 'package:mobile_iot/monitoring/infrastructure/repositories/device_repository_impl.dart';
import 'package:mobile_iot/monitoring/application/device_use_case.dart';
import 'package:mobile_iot/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:mobile_iot/monitoring/domain/entities/event.dart';
import 'package:mobile_iot/monitoring/domain/logic/get_event_status_color.dart';
import 'package:mobile_iot/monitoring/domain/logic/event_type_localization.dart';
import 'package:mobile_iot/monitoring/presentation/widgets/app_header.dart';
import 'package:mobile_iot/monitoring/presentation/widgets/app_search_bar.dart';
import 'package:mobile_iot/monitoring/presentation/widgets/app_empty_state.dart';
import 'package:mobile_iot/monitoring/presentation/widgets/app_error_state.dart';
import 'package:mobile_iot/monitoring/presentation/widgets/app_loading_state.dart';
import 'package:mobile_iot/monitoring/presentation/widgets/app_list_card.dart';
import 'package:mobile_iot/monitoring/presentation/widgets/app_status_badge.dart';
import 'package:mobile_iot/monitoring/presentation/widgets/app_modal_bottom_sheet.dart';
import 'package:mobile_iot/monitoring/presentation/bloc/tank_events/bloc.dart';
import '../../l10n/app_localizations.dart';

import '../../shared/widgets/app_colors.dart';
import '../../shared/widgets/session_expired_screen.dart';
import 'package:mobile_iot/analytics/domain/logic/get_ph_from_status.dart';
import 'package:mobile_iot/monitoring/domain/logic/percentage_formatter.dart';

/// A screen that displays a list of tank events for the authenticated user.
/// 
/// The screen automatically handles:
/// - Loading states while fetching data
/// - Error states with retry functionality
/// - Session expiration and automatic logout
/// - Empty states when no events are found
/// - Device detection and event retrieval
/// 
class TankEventsScreen extends StatefulWidget {
  const TankEventsScreen({Key? key}) : super(key: key);

  @override
  State<TankEventsScreen> createState() => _TankEventsScreenState();
}

class _TankEventsScreenState extends State<TankEventsScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TankEventsBloc>(
      create: (context) => TankEventsBloc(
        deviceUseCase: DeviceUseCase(DeviceRepositoryImpl(DeviceApiService())),
        secureStorage: SecureStorageService(),
        residentApiService: ResidentApiService(),
      )..add(FetchTankEventsEvent()),
      child: BlocConsumer<TankEventsBloc, TankEventsState>(
        // Listen for state changes to handle side effects (like navigation)
        listener: (context, state) {
          if (state is TankEventsSessionExpiredState) {
            Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
          }
        },
        // Build the UI based on the current state
        builder: (context, state) {
          if (state is TankEventsSessionExpiredState) {
            return SessionExpiredScreen(
              onLoginAgain: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              },
            );
          }
          return Scaffold(
            backgroundColor: AppColors.lightGray,
            body: SafeArea(
              child: Column(
                children: [
                  // Header with back navigation
                  AppHeader(
                    title: AppLocalizations.of(context)!.tanksEvents,
                    onBack: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                  ),
                  // Search bar - only show when events are loaded
                  if (state is TankEventsLoadedState) ...[
                    AppSearchBar(
                      controller: _searchController,
                      onChanged: (value) => context.read<TankEventsBloc>().add(SearchTankEventsEvent(value)),
                      hintText: AppLocalizations.of(context)!.searchEvents,
                    ),
                  ],
                  // Main content area
                  Expanded(
                    child: _buildBody(context, state),
                  ),
                ],
              ),
            ),
            // Bottom navigation bar
            bottomNavigationBar: AppBottomNavigationBar(
              currentIndex: 0, // Events tab is active
              onTap: (index) {
                if (index == 1) Navigator.pushReplacementNamed(context, '/dashboard');
                if (index == 2) Navigator.pushReplacementNamed(context, '/profile');
              },
            ),
          );
        },
      ),
    );
  }

  /// Builds the main body content based on the current BLoC state.
  /// 
  /// This method handles different UI states:
  /// - [TankEventsLoadingState]: Shows loading indicator
  /// - [TankEventsErrorState]: Shows error message with retry button
  /// - [TankEventsLoadedState]: Shows the list of events
  /// - Default: Shows loading indicator as fallback
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// - [state]: The current state from the TankEventsBloc
  /// 
  /// Returns a widget that represents the appropriate UI for the current state.
  Widget _buildBody(BuildContext context, TankEventsState state) {
    if (state is TankEventsLoadingState) {
      return const AppLoadingState();
    } else if (state is TankEventsErrorState) {
      return AppErrorState(
        message: state.message,
        onRetry: () => context.read<TankEventsBloc>().add(FetchTankEventsEvent()),
      );
    } else if (state is TankEventsLoadedState) {
      return RefreshIndicator(
        onRefresh: () async => context.read<TankEventsBloc>().add(RefreshTankEventsEvent()),
        child: _buildEventsList(context, state),
      );
    }
    
    // Fallback to loading state
    return const AppLoadingState();
  }

  /// Builds the list of events when data is successfully loaded.
  /// 
  /// This method handles:
  /// - Empty state when no events are found
  /// - List view with all events when data exists
  /// - Pull-to-refresh functionality
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// - [state]: The loaded state containing events data
  /// 
  /// Returns a widget that displays the events list or empty state.
  Widget _buildEventsList(BuildContext context, TankEventsLoadedState state) {
    final events = state.filteredEvents;
    
    // Show empty state if no events match the current search/filter
    if (events.isEmpty) {
      return AppEmptyState(
        title: AppLocalizations.of(context)!.noEventsFound,
        subtitle: AppLocalizations.of(context)!.pullDownToRefresh,
        onAction: () => context.read<TankEventsBloc>().add(RefreshTankEventsEvent()),
        actionText: AppLocalizations.of(context)!.refresh,
      );
    }
    
    // Build list of event items
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: events.length,
      itemBuilder: (context, index) => _buildEventItem(context, events[index], index),
    );
  }

  // Utility to detect 'without water' events in a scalable way
  bool isWithoutWater(BuildContext context, String value) {
    final lower = value.toLowerCase();
    return lower == 'without water' ||
           lower == AppLocalizations.of(context)!.withoutWater.toLowerCase();
  }

  /// Builds an individual event item card.
  /// 
  /// Each event item displays:
  /// - Event type
  /// - Quality value and level value (level shown as percentage)
  /// - Status badge with appropriate colors
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// - [event]: The event entity to display
  /// - [index]: The index of the event in the list
  /// 
  /// Returns a card widget representing a single event.
  Widget _buildEventItem(BuildContext context, Event event, int index) {
    final status = getStatusFromQuality(context, event.qualityValue);
    final isEventWithoutWater = isWithoutWater(context, event.qualityValue);
    
    if (isEventWithoutWater) {
      return AppListCard(
        onTap: () => _showEventDetails(context, event),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event ID and Type row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID:  ${index + 1}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlue,
                  ),
                ),
                Text(
                  getLocalizedEventType(context, event.eventType),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Mensaje especial para sin agua
            Row(
              children: [
                Icon(Icons.do_not_disturb_alt, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.withoutWater + ' - ' +  AppLocalizations.of(context)!.noWaterAnalysisMessage,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: AppStatusBadge(
                text: AppLocalizations.of(context)!.withoutWater,
                backgroundColor: Colors.grey.shade200,
                textColor: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
    
    return AppListCard(
      onTap: () => _showEventDetails(context, event),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event ID and Type row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ID: ${index + 1}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBlue,
                ),
              ),
              Text(
                getLocalizedEventType(context, event.eventType),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Quality and Level values row
          Row(
            children: [
              Expanded(
                child: Text(
                  getLocalizedWaterStatus(context, event.qualityValue),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.mediumGray,
                  ),
                ),
              ),
              Text(
                '${AppLocalizations.of(context)!.level}: ${formatTankEventsPercentage(event.levelValue)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.mediumGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Status badge
          Align(
            alignment: Alignment.centerLeft,
            child: AppStatusBadge(
              text: getEventStatusColor(context, status),
              backgroundColor: getReportStatusColor(status),
              textColor: getReportStatusTextColor(status),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a modal bottom sheet with detailed event information.
  /// 
  /// The modal displays:
  /// - Event icon and type
  /// - Water level information (shown as percentage)
  /// - Detailed information (water quality, status)
  /// - Recommended actions
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// - [event]: The event to show details for
  void _showEventDetails(BuildContext context, Event event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppModalBottomSheet(
        title: AppLocalizations.of(context)!.eventDetails,
        onClose: () => Navigator.pop(context),
        children: [_buildEventDetailsContent(context, event)],
      ),
    );
  }

  /// Builds the content for the event details modal.
  /// 
  /// This method creates a comprehensive view of the event including:
  /// - Header with icon and event type
  /// - Water level information
  /// - Detailed information section
  /// - Recommended actions section
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// - [event]: The event to display details for
  /// 
  /// Returns a scrollable widget with the event details content.
  Widget _buildEventDetailsContent(BuildContext context, Event event) {
    final status = getStatusFromQuality(context, event.qualityValue);
    final isEventWithoutWater = isWithoutWater(context, event.qualityValue);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and event type
          Row(
            children: [
              // Status-colored icon container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isEventWithoutWater ? Colors.grey.shade200 : getReportStatusColor(status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  isEventWithoutWater ? Icons.do_not_disturb_alt : Icons.water_drop,
                  color: isEventWithoutWater ? Colors.grey : getReportStatusTextColor(status),
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event type
                    Text(
                      getLocalizedEventType(context, event.eventType),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    // Water level
                    Text(
                      '${AppLocalizations.of(context)!.waterLevel}: ${formatTankEventsPercentage(event.levelValue)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const Divider(height: 32),
          
          // Details section
          Text(
            AppLocalizations.of(context)!.details,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailItem(AppLocalizations.of(context)!.waterQuality, getLocalizedWaterStatus(context, event.qualityValue)),
          if (!isEventWithoutWater)
            _buildDetailItem(AppLocalizations.of(context)!.status, getEventStatusColor(context, status)),
          const SizedBox(height: 24),
          
          // Actions section
          Text(
            AppLocalizations.of(context)!.recommendedActions,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 12),
          _buildActionItem(AppLocalizations.of(context)!.monitorAnalyticsQualityLevels),
          _buildActionItem(AppLocalizations.of(context)!.checkTankAnalyticsLevel),
          _buildActionItem(AppLocalizations.of(context)!.contactSupportIfIssuesPersist),
        ],
      ),
    );
  }

  /// Builds a detail item row with label and value.
  /// 
  /// This helper method creates a consistent layout for displaying
  /// key-value pairs in the details section.
  /// 
  /// Parameters:
  /// - [label]: The label text (left side)
  /// - [value]: The value text (right side)
  /// 
  /// Returns a row widget with the label and value.
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed width label column
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
          // Flexible value column
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

  /// Builds an action item with a bullet point.
  /// 
  /// This helper method creates a consistent layout for displaying
  /// action items in the actions section.
  /// 
  /// Parameters:
  /// - [action]: The action text to display
  /// 
  /// Returns a row widget with a bullet point and action text.
  Widget _buildActionItem(String action) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bullet point
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
          // Action text
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

