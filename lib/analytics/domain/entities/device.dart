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
  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as int,
      type: json['type'] as String,
      status: json['status'] as String,
      residentId: json['residentId'] as int,
    );
  }
}