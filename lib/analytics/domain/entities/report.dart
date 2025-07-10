/// This entity encapsulates information about user-generated reports,
/// including title, description, creation date, status, and associated
/// resident and provider identifiers.
///
/// The entity provides JSON serialization and deserialization methods
/// for API communication and report management.
class Report{

  final int id;
  final String title;
  final String description;
  final String emissionDate;
  final String status;
  final int residentId;
  final int providerId;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.emissionDate,
    required this.status,
    required this.residentId,
    required this.providerId,
  });

  /// Converts the report to a JSON map for API communication.
  /// 
  /// Returns a Map containing all report properties formatted
  /// according to the backend API specification.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'emissionDate': emissionDate,
      'status': status,
      'residentId': residentId,
      'providerId': providerId,
    };
  }
  
  /// Creates a Report instance from a JSON map.
  /// 
  /// This factory constructor parses JSON data from the API,
  /// casting values to their appropriate types for report properties.
  /// 
  /// Parameters:
  /// - [json]: The JSON map containing report data
  /// 
  /// Returns a new Report instance with parsed data.
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      emissionDate: json['emissionDate'] as String,
      status: json['status'] as String,
      residentId: json['residentId'] as int,
      providerId: json['providerId'] as int
    );
  }
}