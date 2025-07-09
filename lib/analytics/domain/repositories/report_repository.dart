import 'package:mobile_iot/analytics/domain/entities/report.dart';

/// Abstract interface for report data operations.
/// 
/// This repository interface defines the contract for creating and retrieving
/// report data from various data sources. It follows the repository pattern
/// to abstract data access logic from the business logic layer.
/// 
/// Implementations of this interface handle the actual data operations
/// from APIs, local storage, or other data sources.
abstract class ReportRepository {
  /// Creates a new report in the system.
  /// 
  /// This method submits a new report with the specified details
  /// to the backend system using the provided authentication token.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [tittle]: The title of the report
  /// - [description]: The detailed description of the issue or observation
  /// - [status]: The initial status of the report (typically 'received')
  /// 
  /// Returns a Future that completes when the report is successfully created.
  Future<void> createReport(String token, String tittle, String description, String status);
  
  /// Retrieves all reports associated with a specific resident.
  /// 
  /// This method fetches all reports that were created by the specified
  /// resident, using the provided authentication token.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [residentId]: The unique identifier of the resident
  /// 
  /// Returns a Future that completes with a list of Report entities.
  Future<List<Report>> getReportByResidentId(String token, int residentId);
}