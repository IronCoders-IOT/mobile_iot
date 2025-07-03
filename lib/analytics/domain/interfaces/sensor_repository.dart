import 'package:mobile_iot/analytics/domain/entities/sensor.dart';

abstract class SensorRepository {
  Future<List<Sensor>> getSensor(String token, int residentId);
}