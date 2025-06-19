import 'package:mobile_iot/infrastructure/data_sources/event_api_service.dart';
import '../../domain/entities/event.dart';

import '../../domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventApiService eventApiService;

  EventRepositoryImpl(this.eventApiService);

  @override
  Future<List<Event>> getAllEventsBySensorId(String token, int id) {
    return eventApiService.getAllEventsBySensorId(token, id);
  }
}