import 'package:mobile_iot/monitoring/domain/entities/device.dart';
import 'package:mobile_iot/monitoring/domain/repositories/device_repository.dart';

/// Use case for device-related business operations.
/// 
/// This class encapsulates the business logic for retrieving device information.
/// It acts as an intermediary between the presentation layer and the domain layer,
/// ensuring that business rules are applied consistently.
/// 
/// The use case follows the Clean Architecture principle of dependency inversion,
/// depending on the abstract DeviceRepository interface rather than concrete implementations.
class DeviceUseCase{
  final DeviceRepository deviceRepository;
  
  DeviceUseCase(this.deviceRepository);
  
  /// Retrieves devices associated with a specific resident.
  /// 
  /// This method delegates the device retrieval operation to the repository,
  /// maintaining the separation of concerns between business logic and data access.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [id]: The unique identifier of the resident
  /// 
  /// Returns a Future that completes with a list of Device entities.
  Future<List<Device>> getDevice(String token, int id) {
    return deviceRepository.getDevice(token, id);
  }
}