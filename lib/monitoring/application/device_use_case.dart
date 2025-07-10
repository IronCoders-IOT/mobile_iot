import 'package:mobile_iot/monitoring/domain/entities/event.dart';
import 'package:mobile_iot/monitoring/domain/repositories/device_repository.dart';

/// Use case for device-related business operations.
/// 
/// This class encapsulates the business logic for retrieving device information
/// and events.
/// 
class DeviceUseCase{
  final DeviceRepository deviceRepository;
  
  DeviceUseCase(this.deviceRepository);
  
  /// Retrieves events associated with a specific device.
  /// 
  /// This method delegates the event retrieval operation to the repository,
  /// maintaining the separation of concerns between business logic and data access.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [deviceId]: The unique identifier of the device
  /// 
  /// Returns a Future that completes with a list of Event entities.
  Future<List<Event>> getEventsByDeviceId(String token, int deviceId) {
    return deviceRepository.getEventsByDeviceId(token, deviceId);
  }
}