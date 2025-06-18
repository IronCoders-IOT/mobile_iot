abstract class WaterRequestRepository {
  Future<void> createWaterRequest(String token,
      String requestedLiters, String status, String deliveredAt);
}