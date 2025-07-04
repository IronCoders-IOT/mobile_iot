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