import 'package:mobile_iot/analytics/domain/entities/sensor.dart';
import 'package:mobile_iot/analytics/domain/repositories/sensor_repository.dart';
import 'package:mobile_iot/analytics/infrastructure/service/sensor_api_service.dart';

class SensorRepositoryImpl implements SensorRepository {
  final SensorApiService sensorApiService;

  SensorRepositoryImpl(this.sensorApiService);

  @override
  Future<List<Sensor>> getSensor(String token, int id) {
    return sensorApiService.getSensor(token, id);
  }
}