import 'package:mobile_iot/analytics/domain/repositories/event_repository.dart';
import 'package:mobile_iot/analytics/domain/entities/event.dart';

class EventUseCase{
  final EventRepository eventRepository;
  EventUseCase(this.eventRepository);
  Future<List<Event>> getAllEventsBySensorId(String token, int id) {
    return eventRepository.getAllEventsBySensorId(token, id);
  }
}