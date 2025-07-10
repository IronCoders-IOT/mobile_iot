import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/profiles/application/resident_use_case.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/profiles/infrastructure/service/resident_api_service.dart';
import 'package:mobile_iot/profiles/infrastructure/repositories/resident_repository_impl.dart';
import 'package:mobile_iot/analytics/infrastructure/service/water_request_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/repositories/water_request_repository_impl.dart';
import 'package:mobile_iot/analytics/domain/entities/water_request.dart';
import 'package:mobile_iot/analytics/domain/logic/date_formatter.dart';
import 'package:mobile_iot/analytics/domain/logic/status_formatter.dart';
import 'package:mobile_iot/analytics/domain/logic/water_request_status_colors.dart';
import 'package:mobile_iot/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_header.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_empty_state.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_error_state.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_loading_state.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_list_card.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_status_badge.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_modal_bottom_sheet.dart';
import '../../l10n/app_localizations.dart';

import '../../shared/widgets/app_colors.dart';
import 'bloc/water_supply_request/water_supply_request_bloc.dart';
import 'bloc/water_supply_request/water_supply_request_event.dart';
import 'bloc/water_supply_request/water_supply_request_state.dart';
import '../../shared/widgets/session_expired_screen.dart';

/// A screen that displays a list of water supply requests for the authenticated user.
/// 
/// The screen automatically handles:
/// - Loading states while fetching data
/// - Error states with retry functionality
/// - Session expiration and automatic logout
/// - Empty states when no requests are found
/// - Resident profile detection and request retrieval
/// 
class WaterSupplyRequestScreen extends StatelessWidget {
  /// Creates a water supply request screen.
  /// 
  /// The [key] parameter is optional and is passed to the superclass.
  const WaterSupplyRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WaterSupplyRequestBloc>(
      create: (context) => WaterSupplyRequestBloc(
        residentUseCase: ResidentUseCase(ResidentRepositoryImpl(ResidentApiService())),
        waterRequestRepo: WaterRequestRepositoryImpl(WaterRequestApiService()),
        secureStorage: SecureStorageService(),
      )..add(FetchWaterSupplyRequestsEvent()),
      child: BlocConsumer<WaterSupplyRequestBloc, WaterSupplyRequestState>(
        listener: (context, state) {
          if (state is WaterSupplyRequestSessionExpiredState) {
            Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
          }
        },
        builder: (context, state) {
          if (state is WaterSupplyRequestSessionExpiredState) {
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
                  AppHeader(
                    title: AppLocalizations.of(context)!.requestHistory,
                    onBack: () => Navigator.pop(context),
                  ),
                  Expanded(child: _buildBody(context, state)),
                ],
              ),
            ),
            bottomNavigationBar: AppBottomNavigationBar(
              currentIndex: 0,
              onTap: (index) {
                switch (index) {
                  case 0:
                    Navigator.pushReplacementNamed(context, '/reports');
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
        },
      ),
    );
  }

  /// Builds the main body content based on the current BLoC state.
  /// 
  /// This method handles different UI states:
  /// - [WaterSupplyRequestLoadingState]: Shows loading indicator
  /// - [WaterSupplyRequestErrorState]: Shows error message with retry button
  /// - [WaterSupplyRequestLoadedState]: Shows the list of requests
  /// - Default: Shows loading indicator as fallback
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// - [state]: The current state from the WaterSupplyRequestBloc
  /// 
  /// Returns a widget that represents the appropriate UI for the current state.
  Widget _buildBody(BuildContext context, WaterSupplyRequestState state) {
    if (state is WaterSupplyRequestLoadingState) {
      return const AppLoadingState();
    } else if (state is WaterSupplyRequestErrorState) {
      return AppErrorState(
        message: state.message,
        onRetry: () => context.read<WaterSupplyRequestBloc>().add(FetchWaterSupplyRequestsEvent()),
      );
    } else if (state is WaterSupplyRequestLoadedState) {
      return RefreshIndicator(
        onRefresh: () async => context.read<WaterSupplyRequestBloc>().add(RefreshWaterSupplyRequestsEvent()),
        child: _buildRequestsList(context, state),
      );
    }
    
    return const AppLoadingState();
  }

  /// Builds the list of requests when data is successfully loaded.
  /// 
  /// This method handles:
  /// - Empty state when no requests are found
  /// - List view with all requests when data exists
  /// - Pull-to-refresh functionality
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// - [state]: The loaded state containing requests data
  /// 
  /// Returns a widget that displays the requests list or empty state.
  Widget _buildRequestsList(BuildContext context, WaterSupplyRequestLoadedState state) {
    final requests = state.requests;
    
    if (requests.isEmpty) {
      return AppEmptyState(
        title: AppLocalizations.of(context)!.noWaterSupplyRequestsFound,
        subtitle: AppLocalizations.of(context)!.pullDownToRefresh,
        onAction: () => context.read<WaterSupplyRequestBloc>().add(RefreshWaterSupplyRequestsEvent()),
        actionText: AppLocalizations.of(context)!.refresh,
      );
    }
    
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _buildRequestCard(context, requests[index]),
    );
  }

  /// Builds an individual request item card.
  /// 
  /// Each request item displays:
  /// - Water drop icon with status-based colors
  /// - Request title and status badge
  /// - Requested liters amount
  /// - Delivery date
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// - [request]: The water request entity to display
  /// 
  /// Returns a card widget representing a single request.
  Widget _buildRequestCard(BuildContext context, WaterRequest request) {
    return AppListCard(
      onTap: () => _showRequestDetails(context, request),
      child: Row(
        children: [
          Icon(Icons.water_drop, color: WaterRequestStatusColors.getStatusColor(request.status), size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.waterSupplyRequest,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkBlue,
                        ),
                      ),
                    ),
                    AppStatusBadge(
                      text: StatusFormatter.formatWaterRequestStatus(context, request.status),
                      backgroundColor: WaterRequestStatusColors.getStatusBackgroundColor(request.status),
                      textColor: WaterRequestStatusColors.getStatusColor(request.status),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${AppLocalizations.of(context)!.requested}: ${request.requestedLiters} ${AppLocalizations.of(context)!.liters}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.mediumGray,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${AppLocalizations.of(context)!.delivered}: ${DateFormatter.formatDate(context, request.deliveredAt)}',
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
    );
  }

  /// Shows a modal bottom sheet with detailed request information.
  /// 
  /// This method displays a comprehensive view of the request including:
  /// - Request icon with status-based colors
  /// - Full request details and status
  /// - Requested amount and delivery date
  /// - Action suggestions for the user
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// - [request]: The water request entity to display details for
  void _showRequestDetails(BuildContext context, WaterRequest request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppModalBottomSheet(
        title: AppLocalizations.of(context)!.requestDetails,
        onClose: () => Navigator.pop(context),
        children: [_buildRequestDetailsContent(context, request)],
      ),
    );
  }

  /// Builds the content for the request details modal.
  /// 
  /// This method creates a detailed view of the request with:
  /// - Status-colored icon container
  /// - Full request title and status
  /// - Formatted details and delivery information
  /// - Action suggestions with proper styling
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// - [request]: The water request entity to display detailed information for
  /// 
  /// Returns a widget containing the formatted request details.
  Widget _buildRequestDetailsContent(BuildContext context, WaterRequest request) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: WaterRequestStatusColors.getStatusBackgroundColor(request.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.water_drop,
                  color: WaterRequestStatusColors.getStatusColor(request.status),
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.waterSupplyRequest,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    AppStatusBadge(
                      text: StatusFormatter.formatWaterRequestStatus(context, request.status),
                      backgroundColor: WaterRequestStatusColors.getStatusBackgroundColor(request.status),
                      textColor: WaterRequestStatusColors.getStatusColor(request.status),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          Text(
            AppLocalizations.of(context)!.details,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailItem(AppLocalizations.of(context)!.status, StatusFormatter.formatWaterRequestStatus(context, request.status)),
          _buildDetailItem(AppLocalizations.of(context)!.requestedAmount, '${request.requestedLiters} ${AppLocalizations.of(context)!.liters}'),
          _buildDetailItem(AppLocalizations.of(context)!.deliveredAt, DateFormatter.formatDate(context, request.deliveredAt)),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.actions,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 12),
          _buildActionItem(AppLocalizations.of(context)!.monitorRequestStatus),
          _buildActionItem(AppLocalizations.of(context)!.contactSupportIfNeeded),
          _buildActionItem(AppLocalizations.of(context)!.checkWaterSupplyUpdates),
        ],
      ),
    );
  }

  /// Builds a detail item row for the request details modal.
  /// 
  /// This method creates a consistent layout for displaying key-value pairs
  /// with proper spacing and typography.
  /// 
  /// Parameters:
  /// - [label]: The label text (e.g., "Status", "Requested Amount")
  /// - [value]: The value text to display
  /// 
  /// Returns a row widget with label and value properly formatted.
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

  /// Builds an action item row for the request details modal.
  /// 
  /// This method creates a bulleted list item with a small blue dot
  /// and proper spacing for action suggestions.
  /// 
  /// Parameters:
  /// - [action]: The action text to display
  /// 
  /// Returns a row widget with bullet point and action text.
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
