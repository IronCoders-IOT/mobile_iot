import 'package:mobile_iot/monitoring/domain/entities/device.dart';
import 'package:mobile_iot/monitoring/domain/entities/event.dart';
import 'package:mobile_iot/monitoring/domain/repositories/device_repository.dart';
import 'package:mobile_iot/monitoring/infrastructure/service/device_api_service.dart';

/// Concrete implementation of the DeviceRepository interface.
class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceApiService deviceApiService;

  DeviceRepositoryImpl(this.deviceApiService);

  @override
  /// Retrieves events associated with a specific device.
  /// 
  /// This implementation delegates the event retrieval to the API service
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [deviceId]: The unique identifier of the device
  /// 
  /// Returns a Future that completes with a list of Event entities.
  Future<List<Event>> getEventsByDeviceId(String token, int deviceId) {
    return deviceApiService.getEventsByDeviceId(token, deviceId);
  }
}