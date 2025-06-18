import 'package:mobile_iot/infrastructure/data_sources/water_request_api_service.dart';

import '../../domain/repositories/water_request_repository.dart';

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


}