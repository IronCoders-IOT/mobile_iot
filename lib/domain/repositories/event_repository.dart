import '../entities/event.dart';

abstract class EventRepository {

  Future<List<Event>> getAllEventsBySensorId(String token, int id);
}