import 'package:mobile_iot/analytics/infrastructure/service/water_request_api_service.dart';
import 'package:mobile_iot/analytics/domain/entities/water_request.dart';
import 'package:mobile_iot/analytics/domain/repositories/water_request_repository.dart';

/// Concrete implementation of the WaterRequestRepository interface.
/// 
/// This class provides the actual implementation for water request data operations,
/// delegating the work to the WaterRequestApiService for API communication.
/// It follows the repository pattern to abstract data access details
/// from the business logic layer.
class WaterRequestRepositoryImpl implements WaterRequestRepository {
  final WaterRequestApiService waterRequestApiService;

  WaterRequestRepositoryImpl(this.waterRequestApiService);

  @override
  /// Creates a new water supply request in the system.
  /// 
  /// This implementation delegates the water request creation to the API service,
  /// which handles the actual HTTP communication with the backend.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [requestedLiters]: The amount of water requested in liters
  /// - [status]: The initial status of the request (typically 'received')
  /// - [deliveredAt]: The expected or actual delivery date/time
  /// 
  /// Returns a Future that completes when the request is successfully created.

  Future<void> createWaterRequest(
      String token,
      String requestedLiters, String status, String deliveredAt
      ) {
    return waterRequestApiService.createWaterRequest(
        token, requestedLiters, status, deliveredAt);
  }

  @override
  /// Retrieves all water requests associated with a specific resident.
  /// 
  /// This implementation delegates the water request retrieval to the API service,
  /// which handles the actual HTTP communication with the backend.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [id]: The unique identifier of the resident
  /// 
  /// Returns a Future that completes with a list of WaterRequest entities.
  Future<List<WaterRequest>> getAllRequestsByResidentId(String token, int id) {
    return waterRequestApiService.getAllRequestsByResidentId(token, id);
  }
}