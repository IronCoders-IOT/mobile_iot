
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
      'deviceId': deviceId,
    };
  }
  
  /// Creates an Event instance from a JSON map.
  /// 
  /// This factory constructor safely parses JSON data from the API
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
      deviceId: json['deviceId'] as int? ?? 0,
    );
  }
}