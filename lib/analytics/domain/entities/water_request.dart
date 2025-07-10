/// This entity encapsulates information about water delivery requests,
/// including the requested amount, current status, and delivery information.
/// Used for tracking water supply requests and their fulfillment status.
/// 
/// The entity provides JSON serialization and deserialization methods
/// for API communication.
class WaterRequest{
  final String requestedLiters;
  
  final String status;
  
  final String deliveredAt;

  WaterRequest({
    required this.requestedLiters,
    required this.status,
    required this.deliveredAt,
  });

  /// Converts the water request to a JSON map for API communication.
  /// 
  /// Returns a Map containing all water request properties formatted
  /// according to the backend API specification.
  Map<String, dynamic>toJson() {
    return {
      'requestedLiters': requestedLiters,
      'status': status,
      'deliveredAt': deliveredAt,
    };
  }
  
  /// Creates a WaterRequest instance from a JSON map.
  /// 
  /// This factory constructor safely parses JSON data from the API,
  /// providing default values for missing or null fields to ensure
  /// data integrity and prevent runtime errors.
  /// 
  /// Parameters:
  /// - [json]: The JSON map containing water request data
  /// 
  /// Returns a new WaterRequest instance with parsed data.
  factory WaterRequest.fromJson(Map<String, dynamic> json) {
    return WaterRequest(
      requestedLiters: json['requestedLiters']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      deliveredAt: json['emissionDate']?.toString() ?? '',
    );
  }
}