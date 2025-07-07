import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/profiles/infrastructure/service/resident_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/service/device_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/service/event_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/repositories/device_repository_impl.dart';
import 'package:mobile_iot/analytics/infrastructure/repositories/event_repository_impl.dart';
import 'package:mobile_iot/analytics/application/device_use_case.dart';
import 'package:mobile_iot/analytics/application/event_use_case.dart';
import 'package:mobile_iot/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:mobile_iot/analytics/domain/entities/event.dart';
import 'package:mobile_iot/analytics/domain/logic/get_event_status_color.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_header.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_search_bar.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_empty_state.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_error_state.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_loading_state.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_list_card.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_status_badge.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_modal_bottom_sheet.dart';
import 'package:mobile_iot/analytics/presentation/bloc/tank_events/bloc/bloc.dart';

import '../../shared/widgets/app_colors.dart';

/// A screen that displays a list of tank events for the authenticated user.
/// 
/// This screen uses the BLoC pattern for state management and provides the following features:
/// - View all tank events associated with the user's devices
/// - Search events by event type, quality value, or level value
/// - Pull-to-refresh functionality
/// - View detailed event information in a modal
/// - Navigate to other app sections via bottom navigation
/// 
/// The screen automatically handles:
/// - Loading states while fetching data
/// - Error states with retry functionality
/// - Session expiration and automatic logout
/// - Empty states when no events are found
/// - Device detection and event retrieval
/// 
class TankEventsScreen extends StatelessWidget {
  /// Creates a tank events screen.
  /// 
  /// The [key] parameter is optional and is passed to the superclass.
  const TankEventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TankEventsBloc>(
      create: (context) => TankEventsBloc(
        deviceUseCase: DeviceUseCase(DeviceRepositoryImpl(DeviceApiService())),
        eventUseCase: EventUseCase(EventRepositoryImpl(EventApiService())),
        secureStorage: SecureStorageService(),
        residentApiService: ResidentApiService(),
      )..add(FetchTankEventsEvent()),
      child: BlocConsumer<TankEventsBloc, TankEventsState>(
        // Listen for state changes to handle side effects (like navigation)
        listener: (context, state) {
          if (state is TankEventsErrorState && 
              (state.message.contains('Session expired') || 
               state.message.contains('No authentication token'))) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        // Build the UI based on the current state
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.lightGray,
            body: SafeArea(
              child: Column(
                children: [
                  // Header with back navigation
                  AppHeader(
                    title: 'TANKS EVENTS',
                    onBack: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                  ),
                  // Search bar - only show when events are loaded
                  if (state is TankEventsLoadedState) ...[
                    AppSearchBar(
                      controller: TextEditingController(text: state.searchQuery),
                      onChanged: (value) => context.read<TankEventsBloc>().add(SearchTankEventsEvent(value)),
                      hintText: 'Search events...',
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
        title: 'No events found',
        subtitle: 'Pull down to refresh',
        onAction: () => context.read<TankEventsBloc>().add(RefreshTankEventsEvent()),
        actionText: 'Refresh',
      );
    }
    
    // Build list of event items
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: events.length,
      itemBuilder: (context, index) => _buildEventItem(context, events[index], index),
    );
  }

  /// Builds an individual event item card.
  /// 
  /// Each event item displays:
  /// - Event ID (index + 1)
  /// - Event type
  /// - Quality value and level value
  /// - Status badge with appropriate colors
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// - [event]: The event entity to display
  /// - [index]: The index of the event in the list
  /// 
  /// Returns a card widget representing a single event.
  Widget _buildEventItem(BuildContext context, Event event, int index) {
    final status = getStatusFromQuality(event.qualityValue);
    
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
                event.eventType,
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
                  event.qualityValue,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.mediumGray,
                  ),
                ),
              ),
              Text(
                'Level: ${event.levelValue}',
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
              text: getEventStatusColor(status),
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
  /// - Water level information
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
        title: 'Event Details',
        onClose: () => Navigator.pop(context),
        children: [_buildEventDetailsContent(event)],
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
  /// - [event]: The event to display details for
  /// 
  /// Returns a scrollable widget with the event details content.
  Widget _buildEventDetailsContent(Event event) {
    final status = getStatusFromQuality(event.qualityValue);
    
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
                  color: getReportStatusColor(status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.water_drop,
                  color: getReportStatusTextColor(status),
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
                      event.eventType,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    // Water level
                    Text(
                      'Water Level: ${event.levelValue}',
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
          const Text(
            'Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailItem('Water Quality', event.qualityValue),
          _buildDetailItem('Status', getEventStatusColor(status)),
          const SizedBox(height: 24),
          
          // Actions section
          const Text(
            'Recommended Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 12),
          _buildActionItem('1. Monitor analytics quality levels'),
          _buildActionItem('2. Check tank analytics level'),
          _buildActionItem('3. Contact support if issues persist'),
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

