import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/profiles/infrastructure/service/resident_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/service/sensor_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/service/event_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/repositories/sensor_repository_impl.dart';
import 'package:mobile_iot/analytics/infrastructure/repositories/event_repository_impl.dart';
import 'package:mobile_iot/analytics/application/sensor_use_case.dart';
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

import '../../shared/widgets/app_colors.dart';

class TankEventsScreen extends StatefulWidget {
  const TankEventsScreen({Key? key}) : super(key: key);

  @override
  State<TankEventsScreen> createState() => _TankEventsScreenState();
}

class _TankEventsScreenState extends State<TankEventsScreen> {
  // API-driven data
  List<Event> events = [];
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
      final fetchedEvents = await eventUseCase.getAllEventsBySensorId(token, sensorId);
      setState(() {
        events = fetchedEvents;
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
  String _getStatusFromQuality(String quality) {
    switch (quality.toLowerCase()) {
      case 'mala':
      case 'no potable':
        return 'alert';
      case 'agua contaminada':
        return 'critical';
      default:
        return 'normal';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtered events based on search query
  List<Event> get filteredEvents {
    if (_searchQuery.isEmpty) {
      return events;
    }
    return events.where((event) {
      return event.eventType.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             event.qualityValue.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             event.levelValue.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _showEventDetails(Event event) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            AppHeader(
              title: 'TANKS HISTORY',
              onBack: () => Navigator.pushReplacementNamed(context, '/dashboard'),
            ),
            
            // Search Bar
            AppSearchBar(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              hintText: 'Search events...',
            ),
            
            // Lista de eventos
            Expanded(
              child: _isLoading
                  ? const AppLoadingState()
                  : _error != null
                      ? AppErrorState(
                          message: _error!,
                          onRetry: _fetchHistory,
                        )
                      : _buildEventsList(),
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

  Widget _buildEventsList() {
    final eventsToShow = filteredEvents;
    
    if (eventsToShow.isEmpty) {
      return AppEmptyState(
        title: 'No events found',
        subtitle: 'Pull down to refresh',
        onAction: _fetchHistory,
        actionText: 'Refresh',
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchHistory,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: eventsToShow.length,
        itemBuilder: (context, index) {
          final event = eventsToShow[index];
          return _buildEventItem(event, index);
        },
      ),
    );
  }

  Widget _buildEventItem(Event event, int index) {
    final status = _getStatusFromQuality(event.qualityValue);
    
    return AppListCard(
      onTap: () => _showEventDetails(event),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ID and Event
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
          // Water Quality and Level
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
          // Status
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

  Widget _buildEventDetailsContent(Event event) {
    final status = _getStatusFromQuality(event.qualityValue);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Row(
            children: [
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
                    Text(
                      event.eventType,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                    ),
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
          
          // Recommended Actions section
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

