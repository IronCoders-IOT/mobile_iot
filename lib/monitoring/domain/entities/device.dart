/// Represents a water tank sensor device in the IoT system.
/// 
/// This entity encapsulates information about physical sensor devices
/// that monitor water tanks, including their identification, type,
/// operational status, and associated resident.
/// 
/// The entity provides JSON serialization capabilities for API communication.
class Device{
  final int id;
  
  final String type;
  
  final String status;
  
  final int residentId;
  
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