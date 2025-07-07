import 'package:mobile_iot/analytics/domain/entities/device.dart';

abstract class DeviceRepository {
  Future<List<Device>> getDevice(String token, int residentId);
}