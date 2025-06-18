class WaterRequest{
 //final int residentId;
  // final int providerId;
  final String requestedLiters;
  final String status;
  final String deliveredAt;
  WaterRequest({
    required this.requestedLiters,
    required this.status,
    required this.deliveredAt,
  });

  Map<String, dynamic>toJson() {
    return {
      'requestedLiters': requestedLiters,
      'status': status,
      'deliveredAt': deliveredAt,
    };
  }
}