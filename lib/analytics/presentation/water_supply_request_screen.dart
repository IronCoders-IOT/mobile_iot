import 'package:flutter/material.dart';
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
import 'package:mobile_iot/shared/exceptions/session_expired_exception.dart';

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
    } on SessionExpiredException catch (e) {
      await _secureStorage.deleteToken();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
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
          Icon(Icons.water_drop, color: WaterRequestStatusColors.getStatusColor(req.status), size: 32),
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
                      text: StatusFormatter.formatWaterRequestStatus(req.status),
                      backgroundColor: WaterRequestStatusColors.getStatusBackgroundColor(req.status),
                      textColor: WaterRequestStatusColors.getStatusColor(req.status),
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
                  'Delivered: ${DateFormatter.formatDate(req.deliveredAt)}',
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
                    const Text(
                      'Water Supply Request',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    AppStatusBadge(
                      text: StatusFormatter.formatWaterRequestStatus(request.status),
                      backgroundColor: WaterRequestStatusColors.getStatusBackgroundColor(request.status),
                      textColor: WaterRequestStatusColors.getStatusColor(request.status),
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
          _buildDetailItem('Status', StatusFormatter.formatWaterRequestStatus(request.status)),
          _buildDetailItem('Requested Amount', '${request.requestedLiters} liters'),
          _buildDetailItem('Delivered At', DateFormatter.formatDate(request.deliveredAt)),
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
