import 'package:mobile_iot/analytics/infrastructure/service/report_api_service.dart';
import 'package:mobile_iot/analytics/domain/entities/report.dart';
import 'package:mobile_iot/analytics/domain/repositories/report_repository.dart';

/// Concrete implementation of the ReportRepository interface.
/// 
/// This class provides the actual implementation for report data operations,
/// delegating the work to the ReportApiService for API communication.
/// It follows the repository pattern to abstract data access details
/// from the business logic layer.
class ReportRepositoryImpl implements ReportRepository {

  /// The API service instance used for HTTP communication with the backend.
  final ReportApiService reportApiService;
  
  /// Creates a report repository implementation with the specified API service.
  /// 
  /// Parameters:
  /// - [reportApiService]: The API service to use for backend communication
  ReportRepositoryImpl(this.reportApiService);
  
  @override
  /// Creates a new report in the system.
  /// 
  /// This implementation delegates the report creation to the API service,
  /// which handles the actual HTTP communication with the backend.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [title]: The title of the report
  /// - [description]: The detailed description of the issue or observation
  /// - [status]: The initial status of the report (typically 'received')
  /// 
  /// Returns a Future that completes with a success message or error details.
  /// 
  /// Throws:
  /// - [SessionExpiredException] when the authentication token is invalid
  /// - [Exception] for other network or data access errors
  Future<String?> createReport(String token, String title, String description, String status) {
    return reportApiService.createReport(token, title, description, status);
  }
  
  @override
  /// Retrieves all reports associated with a specific resident.
  /// 
  /// This implementation delegates the report retrieval to the API service,
  /// which handles the actual HTTP communication with the backend.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [residentId]: The unique identifier of the resident
  /// 
  /// Returns a Future that completes with a list of Report entities.
  /// 
  /// Throws:
  /// - [SessionExpiredException] when the authentication token is invalid
  /// - [Exception] for other network or data access errors
  Future<List<Report>> getReportByResidentId(String token, int residentId) {
    return reportApiService.getReportByResidentId(token, residentId);
  }
}