class Device{
  final int id;
  
  final String type;
  
  final String status;
  final String description;
  final int residentId;
  
  Device({
    required this.id,
    required this.type,
    required this.status,
    required this.residentId,
    required this.description,
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
      description: json['description'] as String,
    );
  }
}