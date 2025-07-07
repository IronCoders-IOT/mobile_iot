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
  Map<String, dynamic> toJson() {
    return {
      'eventType': eventType,
      'qualityValue': qualityValue,
      'levelValue': levelValue,
      'sensorId': deviceId,
    };
  }
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventType: json['eventType']?.toString() ?? '',
      qualityValue: json['qualityValue']?.toString() ?? '',
      levelValue: json['levelValue']?.toString() ?? '',
      deviceId: json['sensorId'] as int? ?? 0,
    );
  }

}