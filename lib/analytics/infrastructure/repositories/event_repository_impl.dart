import 'package:mobile_iot/analytics/infrastructure/data_sources/event_api_service.dart';
import 'package:mobile_iot/analytics/domain/entities/event.dart';
import 'package:mobile_iot/analytics/domain/interfaces/event_repository.dart';


class EventRepositoryImpl implements EventRepository {
  final EventApiService eventApiService;

  EventRepositoryImpl(this.eventApiService);

  @override
  Future<List<Event>> getAllEventsBySensorId(String token, int id) {
    return eventApiService.getAllEventsBySensorId(token, id);
  }
}