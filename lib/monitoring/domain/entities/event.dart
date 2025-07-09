/// Represents an event from a water tank sensor device.
/// 
/// This entity encapsulates data about water quality and level readings
/// from IoT sensors, including the event type, quality metrics, water level,
/// and associated device identification.
/// 
/// The entity provides methods for JSON serialization and deserialization
/// to facilitate data exchange with the backend API.
class Event{
  final String eventType;
  
  final String qualityValue;
  
  final String levelValue;
  
  final int deviceId;

  Event({
    required this.eventType,
    required this.qualityValue,
    required this.levelValue,
    required this.deviceId,
  });
  
  /// Converts the event to a JSON map for API communication.
  /// 
  /// Returns a Map containing all event properties formatted
  /// according to the backend API specification.
  Map<String, dynamic> toJson() {
    return {
      'eventType': eventType,
      'qualityValue': qualityValue,
      'levelValue': levelValue,
      'sensorId': deviceId,
    };
  }
  
  /// Creates an Event instance from a JSON map.
  /// 
  /// This factory constructor safely parses JSON data from the API,
  /// providing default values for missing or null fields to ensure
  /// data integrity and prevent runtime errors.
  /// 
  /// Parameters:
  /// - [json]: The JSON map containing event data
  /// 
  /// Returns a new Event instance with parsed data.
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventType: json['eventType']?.toString() ?? '',
      qualityValue: json['qualityValue']?.toString() ?? '',
      levelValue: json['levelValue']?.toString() ?? '',
      deviceId: json['sensorId'] as int? ?? 0,
    );
  }
}