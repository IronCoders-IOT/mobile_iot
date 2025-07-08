import 'package:mobile_iot/analytics/domain/entities/device.dart';
import 'package:mobile_iot/analytics/domain/repositories/device_repository.dart';
import 'package:mobile_iot/analytics/infrastructure/service/device_api_service.dart';

/// Concrete implementation of the DeviceRepository interface.
/// 
/// This class provides the actual implementation for device data operations,
/// delegating the work to the DeviceApiService for API communication.
/// It follows the repository pattern to abstract data access details
/// from the business logic layer.
class DeviceRepositoryImpl implements DeviceRepository {
  /// The API service instance used for HTTP communication with the backend.
  final DeviceApiService deviceApiService;

  /// Creates a device repository implementation with the specified API service.
  /// 
  /// Parameters:
  /// - [deviceApiService]: The API service to use for backend communication
  DeviceRepositoryImpl(this.deviceApiService);

  @override
  /// Retrieves devices associated with a specific resident.
  /// 
  /// This implementation delegates the device retrieval to the API service,
  /// which handles the actual HTTP communication with the backend.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [id]: The unique identifier of the resident
  /// 
  /// Returns a Future that completes with a list of Device entities.
  /// 
  /// Throws:
  /// - [SessionExpiredException] when the authentication token is invalid
  /// - [Exception] for other network or data access errors
  Future<List<Device>> getDevice(String token, int id) {
    return deviceApiService.getDevice(token, id);
  }
}