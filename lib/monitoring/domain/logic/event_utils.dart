import '../entities/event.dart';

/// Returns a map of deviceId to the most recent event for each tank.
/// Assumes the input list is in chronological order (oldest to newest).
Map<String, Event> getLatestEventsByTank(List<Event> events) {
  final Map<String, Event> latestEventsByTank = {};
  for (final event in events) {
    latestEventsByTank[event.deviceId.toString()] = event;
  }
  return latestEventsByTank;
} 