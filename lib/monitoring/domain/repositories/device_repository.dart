import 'package:mobile_iot/monitoring/domain/entities/device.dart';

/// Abstract interface for device data operations.
/// 
/// This repository interface defines the contract for retrieving
/// device information from various data sources. It follows the
/// repository pattern to abstract data access logic from the
/// business logic layer.
/// 
/// Implementations of this interface handle the actual data retrieval
/// from APIs, local storage, or other data sources.
abstract class DeviceRepository {
  /// Retrieves a list of devices associated with a specific resident.
  /// 
  /// This method fetches all devices that belong to or are managed by
  /// the specified resident, using the provided authentication token.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [residentId]: The unique identifier of the resident
  /// 
  /// Returns a Future that completes with a list of Device entities.
  Future<List<Device>> getDevice(String token, int residentId);
}