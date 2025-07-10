import 'package:mobile_iot/analytics/domain/repositories/report_repository.dart';
import 'package:mobile_iot/analytics/domain/entities/report.dart';

/// Use case for report-related business operations.
/// 
/// This class encapsulates the business logic for creating and retrieving reports.
/// It acts as an intermediary between the presentation layer and the domain layer,
/// ensuring that business rules are applied consistently.
/// 
/// The use case follows the Clean Architecture principle of dependency inversion,
/// depending on the abstract ReportRepository interface rather than concrete implementations.
class ReportUseCase{
  final ReportRepository reportRepository;
  
  ReportUseCase(this.reportRepository);
  
  /// Creates a new report in the system.
  /// 
  /// This method delegates the report creation operation to the repository,
  /// maintaining the separation of concerns between business logic and data access.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [title]: The title of the report
  /// - [description]: The detailed description of the issue or observation
  /// - [status]: The initial status of the report (typically 'received')
  /// 
  /// Returns a Future that completes when the report is successfully created.
  Future<void> createReport(String token, String title, String description, String status) {
    return reportRepository.createReport(token, title, description, status);
  }
  
  /// Retrieves all reports associated with a specific resident.
  /// 
  /// This method delegates the report retrieval operation to the repository,
  /// maintaining the separation of concerns between business logic and data access.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [residentId]: The unique identifier of the resident
  /// 
  /// Returns a Future that completes with a list of Report entities.
  Future<List<Report>> getReportByResidentId(String token, int residentId) {
    return reportRepository.getReportByResidentId(token, residentId);
  }
}