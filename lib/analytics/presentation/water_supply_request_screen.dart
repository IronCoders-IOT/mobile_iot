import 'package:flutter/material.dart';
import 'package:mobile_iot/profiles/application/resident_use_case.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/profiles/infrastructure/service/resident_api_service.dart';
import 'package:mobile_iot/profiles/infrastructure/repositories/resident_repository_impl.dart';
import 'package:mobile_iot/analytics/infrastructure/service/water_request_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/repositories/water_request_repository_impl.dart';
import 'package:mobile_iot/analytics/domain/entities/water_request.dart';
import 'package:intl/intl.dart';
import 'package:mobile_iot/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_header.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_empty_state.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_error_state.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_loading_state.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_list_card.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_status_badge.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_modal_bottom_sheet.dart';

import '../../shared/widgets/app_colors.dart';

class WaterSupplyRequestScreen extends StatefulWidget {
  const WaterSupplyRequestScreen({super.key});

  @override
  State<WaterSupplyRequestScreen> createState() => _WaterSupplyRequestScreenState();
}

class _WaterSupplyRequestScreenState extends State<WaterSupplyRequestScreen> {
  late SecureStorageService _secureStorage;
  late ResidentUseCase _residentUseCase;
  late WaterRequestRepositoryImpl _waterRequestRepo;

  bool _isLoading = true;
  String? _error;
  List<WaterRequest> _requests = [];

  @override
  void initState() {
    super.initState();
    _secureStorage = SecureStorageService();
    _residentUseCase = ResidentUseCase(ResidentRepositoryImpl(ResidentApiService()));
    _waterRequestRepo = WaterRequestRepositoryImpl(WaterRequestApiService());
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final token = await _secureStorage.getToken();
      if (token == null) throw Exception('No authentication token found');
      final profile = await _residentUseCase.getProfile(token);
      if (profile == null) throw Exception('Could not load profile');
      final residentId = profile.id;
      if (residentId == null) throw Exception('Resident ID not found in profile');
      final requests = await _waterRequestRepo.getAllRequestsByResidentId(token, residentId);
      setState(() {
        _requests = requests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('MMMM d, yyyy, h:mm a').format(date); // Example: June 10, 2025, 12:36 PM
    } catch (e) {
      return isoString; // fallback if parsing fails
    }
  }

  String formatStatus(String status) {
    return status.replaceAll('_', ' ').toUpperCase();
  }

  Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'IN_PROGRESS':
        return const Color(0xFF3498DB);
      case 'RECEIVED':
        return const Color(0xFF28A745);
      case 'CLOSED':
        return const Color(0xFFE74C3C);
      default:
        return const Color(0xFF6C757D);
    }
  }

  Color getStatusBackgroundColor(String status) {
    switch (status.toUpperCase()) {
      case 'IN_PROGRESS':
        return const Color(0xFFD6ECFF); // light blue
      case 'RECEIVED':
        return const Color(0xFFD6FFE6); // light green
      case 'CLOSED':
        return const Color(0xFFFFEBEE); // light red
      default:
        return AppColors.mediumGray.withOpacity(0.1);
    }
  }

  void _showRequestDetails(WaterRequest request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppModalBottomSheet(
        title: 'Request Details',
        onClose: () => Navigator.pop(context),
        children: [_buildRequestDetailsContent(request)],
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
            AppHeader(
              title: 'Request History',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: _isLoading
                  ? const AppLoadingState()
                  : _error != null
                      ? AppErrorState(
                          message: _error!,
                          onRetry: _fetchRequests,
                        )
                      : _requests.isEmpty
                          ? AppEmptyState(
                              title: 'No water supply requests found',
                              subtitle: 'Pull down to refresh',
                              onAction: _fetchRequests,
                              actionText: 'Refresh',
                            )
                          : RefreshIndicator(
                              onRefresh: _fetchRequests,
                              child: ListView.separated(
                                padding: const EdgeInsets.all(20),
                                itemCount: _requests.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  final req = _requests[index];
                                  return _buildRequestCard(req);
                                },
                              ),
                            ),
            ),
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
  }

  Widget _buildRequestCard(WaterRequest req) {
    return AppListCard(
      onTap: () => _showRequestDetails(req),
      child: Row(
        children: [
          Icon(Icons.water_drop, color: getStatusColor(req.status), size: 32),
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
                        'Water Supply Request',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkBlue,
                        ),
                      ),
                    ),
                    AppStatusBadge(
                      text: formatStatus(req.status),
                      backgroundColor: getStatusBackgroundColor(req.status),
                      textColor: getStatusColor(req.status),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Requested: ${req.requestedLiters} liters',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.mediumGray,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Delivered: ${formatDate(req.deliveredAt)}',
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

  Widget _buildRequestDetailsContent(WaterRequest request) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and status
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: getStatusBackgroundColor(request.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.water_drop,
                  color: getStatusColor(request.status),
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Water Supply Request',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    AppStatusBadge(
                      text: formatStatus(request.status),
                      backgroundColor: getStatusBackgroundColor(request.status),
                      textColor: getStatusColor(request.status),
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
          _buildDetailItem('Status', formatStatus(request.status)),
          _buildDetailItem('Requested Amount', '${request.requestedLiters} liters'),
          _buildDetailItem('Delivered At', formatDate(request.deliveredAt)),
          const SizedBox(height: 24),
          
          // Actions section
          const Text(
            'Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 12),
          _buildActionItem('1. Monitor request status'),
          _buildActionItem('2. Contact support if needed'),
          _buildActionItem('3. Check water supply updates'),
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
