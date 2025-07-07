import 'package:mobile_iot/analytics/domain/entities/device.dart';
import 'package:mobile_iot/analytics/domain/repositories/device_repository.dart';

class DeviceUseCase{
  final DeviceRepository deviceRepository;
  DeviceUseCase(this.deviceRepository);
  Future<List<Device>> getDevice(String token, int id) {
    return deviceRepository.getDevice(token, id);
  }
}