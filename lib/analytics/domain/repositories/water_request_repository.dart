import 'package:mobile_iot/analytics/domain/entities/water_request.dart';

/// Abstract interface for water request data operations.
/// 
/// This repository interface defines the contract for creating and retrieving
/// water request data from various data sources. It follows the repository pattern
/// to abstract data access logic from the business logic layer.
/// 
/// Implementations of this interface handle the actual data operations
/// from APIs, local storage, or other data sources.
abstract class WaterRequestRepository {
  /// Creates a new water supply request in the system.
  /// 
  /// This method submits a new water request with the specified details
  /// to the backend system using the provided authentication token.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [requestedLiters]: The amount of water requested in liters
  /// - [status]: The initial status of the request (typically 'received')
  /// - [deliveredAt]: The expected or actual delivery date/time
  /// 
  /// Returns a Future that completes when the request is successfully created.
  Future<void> createWaterRequest(String token,
      String requestedLiters, String status, String deliveredAt);
  
  /// Retrieves all water requests associated with a specific resident.
  /// 
  /// This method fetches all water supply requests that were created by
  /// the specified resident, using the provided authentication token.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [id]: The unique identifier of the resident
  /// 
  /// Returns a Future that completes with a list of WaterRequest entities.
  Future<List<WaterRequest>> getAllRequestsByResidentId(String token, int id);
}