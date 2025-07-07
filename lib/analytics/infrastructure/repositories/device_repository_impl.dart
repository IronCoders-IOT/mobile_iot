import 'package:mobile_iot/analytics/domain/entities/device.dart';
import 'package:mobile_iot/analytics/domain/repositories/device_repository.dart';
import 'package:mobile_iot/analytics/infrastructure/service/device_api_service.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceApiService deviceApiService;

  DeviceRepositoryImpl(this.deviceApiService);

  @override
  Future<List<Device>> getDevice(String token, int id) {
    return deviceApiService.getDevice(token, id);
  }
}