import 'package:mobile_iot/analytics/domain/entities/water_request.dart';

abstract class WaterRequestRepository {
  Future<void> createWaterRequest(String token,
      String requestedLiters, String status, String deliveredAt);
  Future<List<WaterRequest>> getAllRequestsByResidentId(String token, int id);
}