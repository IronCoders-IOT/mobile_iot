import 'package:mobile_iot/analytics/domain/entities/event.dart';
import 'package:mobile_iot/analytics/domain/repositories/event_repository.dart';
import 'package:mobile_iot/analytics/infrastructure/service/event_api_service.dart';

/// Concrete implementation of the EventRepository interface.
/// 
/// This class provides the actual implementation for event data operations,
/// delegating the work to the EventApiService for API communication.
/// It follows the repository pattern to abstract data access details
/// from the business logic layer.
class EventRepositoryImpl implements EventRepository {
  /// The API service instance used for HTTP communication with the backend.
  final EventApiService eventApiService;

  /// Creates an event repository implementation with the specified API service.
  /// 
  /// Parameters:
  /// - [eventApiService]: The API service to use for backend communication
  EventRepositoryImpl(this.eventApiService);

  @override
  /// Retrieves all events associated with a specific sensor device.
  /// 
  /// This implementation delegates the event retrieval to the API service,
  /// which handles the actual HTTP communication with the backend.
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
    return eventApiService.getAllEventsBySensorId(token, id);
  }
}