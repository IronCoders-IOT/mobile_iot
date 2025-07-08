import 'package:mobile_iot/analytics/domain/entities/event.dart';
import 'package:mobile_iot/analytics/domain/repositories/event_repository.dart';

/// Use case for event-related business operations.
/// 
/// This class encapsulates the business logic for retrieving sensor event data.
/// It acts as an intermediary between the presentation layer and the domain layer,
/// ensuring that business rules are applied consistently.
/// 
/// The use case follows the Clean Architecture principle of dependency inversion,
/// depending on the abstract EventRepository interface rather than concrete implementations.
class EventUseCase{
  /// The repository instance used for data access operations.
  final EventRepository eventRepository;
  
  /// Creates an event use case with the specified repository.
  /// 
  /// Parameters:
  /// - [eventRepository]: The repository implementation to use for data access
  EventUseCase(this.eventRepository);
  
  /// Retrieves all events associated with a specific sensor device.
  /// 
  /// This method delegates the event retrieval operation to the repository,
  /// maintaining the separation of concerns between business logic and data access.
  /// 
  /// Parameters:
  /// - [token]: The authentication token for API access
  /// - [id]: The unique identifier of the sensor device
  /// 
  /// Returns a Future that completes with a list of Event entities.
  /// 
  /// Throws:
  /// - [SessionExpiredException] when the authentication token is invalid
  /// - [Exception] for other network or data access errors
  Future<List<Event>> getAllEventsBySensorId(String token, int id) {
    return eventRepository.getAllEventsBySensorId(token, id);
  }
}