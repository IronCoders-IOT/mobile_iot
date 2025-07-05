import 'package:mobile_iot/analytics/infrastructure/service/event_api_service.dart';
import 'package:mobile_iot/analytics/domain/entities/event.dart';
import 'package:mobile_iot/analytics/domain/repositories/event_repository.dart';


class EventRepositoryImpl implements EventRepository {
  final EventApiService eventApiService;

  EventRepositoryImpl(this.eventApiService);

  @override
  Future<List<Event>> getAllEventsBySensorId(String token, int id) {
    return eventApiService.getAllEventsBySensorId(token, id);
  }
}