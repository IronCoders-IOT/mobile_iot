import 'package:mobile_iot/analytics/domain/entities/device.dart';
import 'package:mobile_iot/analytics/domain/repositories/device_repository.dart';

/// Use case for device-related business operations.
/// 
/// This class encapsulates the business logic for retrieving device information.
/// It acts as an intermediary between the presentation layer and the domain layer,
/// ensuring that business rules are applied consistently.
/// 
/// The use case follows the Clean Architecture principle of dependency inversion,
/// depending on the abstract DeviceRepository interface rather than concrete implementations.
class DeviceUseCase{
  /// The repository instance used for data access operations.
  final DeviceRepository deviceRepository;
  
  /// Creates a device use case with the specified repository.
  /// 
  /// Parameters:
  /// - [deviceRepository]: The repository implementation to use for data access
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
  /// 
  /// Throws:
  /// - [SessionExpiredException] when the authentication token is invalid
  /// - [Exception] for other network or data access errors
  Future<List<Device>> getDevice(String token, int id) {
    return deviceRepository.getDevice(token, id);
  }
}