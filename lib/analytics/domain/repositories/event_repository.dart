import 'package:mobile_iot/analytics/domain/entities/event.dart';

abstract class EventRepository {

  Future<List<Event>> getAllEventsBySensorId(String token, int id);
}