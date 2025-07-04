import 'package:mobile_iot/analytics/infrastructure/data_sources/water_request_api_service.dart';
import 'package:mobile_iot/analytics/domain/entities/water_request.dart';
import 'package:mobile_iot/analytics/domain/interfaces/water_request_repository.dart';


class WaterRequestRepositoryImpl implements WaterRequestRepository {
  final WaterRequestApiService waterRequestApiService;

  WaterRequestRepositoryImpl(this.waterRequestApiService);

  @override
  Future<void> createWaterRequest(
      String token,
      String requestedLiters, String status, String deliveredAt
      ) {
    return waterRequestApiService.createWaterRequest(
        token, requestedLiters, status, deliveredAt);
  }

  @override
  Future<List<WaterRequest>> getAllRequestsByResidentId(String token, int id) {
    return waterRequestApiService.getAllRequestsByResidentId(token, id);
  }
}