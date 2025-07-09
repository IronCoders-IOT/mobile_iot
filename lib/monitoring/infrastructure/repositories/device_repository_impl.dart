import 'package:mobile_iot/monitoring/domain/entities/device.dart';
import 'package:mobile_iot/monitoring/domain/repositories/device_repository.dart';
import 'package:mobile_iot/monitoring/infrastructure/service/device_api_service.dart';

/// Concrete implementation of the DeviceRepository interface.
/// 
/// This class provides the actual implementation for device data operations,
/// delegating the work to the DeviceApiService for API communication.
/// It follows the repository pattern to abstract data access details
/// from the business logic layer.
class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceApiService deviceApiService;

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
  Future<List<Device>> getDevice(String token, int id) {
    return deviceApiService.getDevice(token, id);
  }
}