/// Represents a water tank sensor device in the IoT system.
/// 
/// This entity encapsulates information about physical sensor devices
/// that monitor water tanks, including their identification, type,
/// operational status, and associated resident.
/// 
/// The entity provides JSON serialization capabilities for API communication.
class Device{
  /// The unique identifier for the sensor device.
  final int id;
  
  /// The type of sensor (e.g., 'water_level', 'quality_sensor').
  final String type;
  
  /// The current operational status of the device (e.g., 'active', 'inactive').
  final String status;
  
  /// The identifier of the resident who owns/manages this device.
  final int residentId;
  
  /// Creates a device with the specified parameters.
  /// 
  /// All parameters are required and represent the core device
  /// information stored in the system.
  Device({
    required this.id,
    required this.type,
    required this.status,
    required this.residentId,
  });
  
  /// Creates a Device instance from a JSON map.
  /// 
  /// This factory constructor parses JSON data from the API,
  /// casting values to their appropriate types for device properties.
  /// 
  /// Parameters:
  /// - [json]: The JSON map containing device data
  /// 
  /// Returns a new Device instance with parsed data.
  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as int,
      type: json['type'] as String,
      status: json['status'] as String,
      residentId: json['residentId'] as int,
    );
  }
}