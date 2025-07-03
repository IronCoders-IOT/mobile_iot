import 'package:mobile_iot/analytics/domain/interfaces/event_repository.dart';
import 'package:mobile_iot/analytics/domain/entities/event.dart';

class EventUseCase{
  final EventRepository _eventRepository;
  EventUseCase(this._eventRepository);
  Future<List<Event>> getAllEventsBySensorId(String token, int id) {
    return _eventRepository.getAllEventsBySensorId(token, id);
  }
}