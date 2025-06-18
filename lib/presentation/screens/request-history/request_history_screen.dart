import 'package:flutter/material.dart';
import 'package:mobile_iot/application/use_cases/resident_use_case.dart';
import 'package:mobile_iot/core/services/secure_storage_service.dart';
import 'package:mobile_iot/infrastructure/data_sources/resident_api_service.dart';
import 'package:mobile_iot/infrastructure/repositories/resident_repository_impl.dart';
import 'package:mobile_iot/infrastructure/data_sources/water_request_api_service.dart';
import 'package:mobile_iot/infrastructure/repositories/water_request_repository_impl.dart';
import 'package:mobile_iot/domain/entities/water_request.dart';
import 'package:intl/intl.dart';

class RequestHistoryScreen extends StatefulWidget {
  const RequestHistoryScreen({super.key});

  @override
  State<RequestHistoryScreen> createState() => _RequestHistoryState();
}

class _RequestHistoryState extends State<RequestHistoryScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _error!,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchRequests,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : _requests.isEmpty
                          ? const Center(child: Text('No water requests found.'))
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
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF2C3E50),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Request History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(WaterRequest req) {
    Color statusColor;
    switch (req.status.toUpperCase()) {
      case 'IN_PROGRESS':
        statusColor = const Color(0xFF3498DB);
        break;
      case 'RECEIVED':
        statusColor = const Color(0xFF28A745);
        break;
      case 'CLOSED':
        statusColor = const Color(0xFFE74C3C);
        break;
      default:
        statusColor = const Color(0xFF6C757D);
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.water_drop, color: statusColor, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${req.requestedLiters} Liters',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Status: ${req.status}',
                  style: TextStyle(
                    fontSize: 14,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Emission Date: ${formatDate(req.deliveredAt)}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6C757D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF3498DB),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.description, 0, false),
          _buildNavItem(context, Icons.home, 1, false),
          _buildNavItem(context, Icons.person, 2, false),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, int index, bool isActive) {
    return GestureDetector(
      onTap: () {
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
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
          size: 28,
        ),
      ),
    );
  }
}
