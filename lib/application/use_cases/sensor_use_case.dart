import 'package:mobile_iot/domain/entities/sensor.dart';
import 'package:mobile_iot/domain/repositories/sensor_repository.dart';

class SensorUseCase{
  final SensorRepository _sensorRepository;
  SensorUseCase(this._sensorRepository);
  Future<List<Sensor>> getSensor(String token, int id) {
    return _sensorRepository.getSensor(token, id);
  }
}