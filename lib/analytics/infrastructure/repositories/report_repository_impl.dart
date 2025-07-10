import 'package:mobile_iot/analytics/infrastructure/service/report_api_service.dart';
import 'package:mobile_iot/profiles/infrastructure/service/resident_api_service.dart';
import 'package:mobile_iot/analytics/domain/entities/report.dart';
import 'package:mobile_iot/analytics/domain/repositories/report_repository.dart';

/// This class provides the actual implementation for report data operations
class ReportRepositoryImpl implements ReportRepository {

  final ReportApiService reportApiService;
  final ResidentApiService residentApiService;
  
  ReportRepositoryImpl({
    required this.reportApiService,
    required this.residentApiService,
  });
  
  @override
  /// Creates a new report in the system.
  /// 
  /// This implementation delegates the report creation to the API service
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [title]: The title of the report
  /// - [description]: The detailed description of the issue or observation
  /// - [status]: The initial status of the report (typically 'received')
  /// 
  /// Returns a Future that completes with a success message or error details.
  Future<String?> createReport(String token, String title, String description, String status) {
    return reportApiService.createReport(token, title, description, status);
  }
  
  @override
  /// Retrieves all reports associated with a specific resident.
  /// 
  /// This implementation delegates the report retrieval to the resident API service
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [residentId]: The unique identifier of the resident
  /// 
  /// Returns a Future that completes with a list of Report entities.
  Future<List<Report>> getReportByResidentId(String token, int residentId) {
    return residentApiService.getReportByResidentId(token, residentId);
  }
}