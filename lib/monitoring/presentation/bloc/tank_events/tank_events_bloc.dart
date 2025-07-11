import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/monitoring/application/device_use_case.dart';
import 'package:mobile_iot/monitoring/domain/entities/event.dart';
import 'package:mobile_iot/monitoring/presentation/bloc/tank_events/tank_events_event.dart';
import 'package:mobile_iot/monitoring/presentation/bloc/tank_events/tank_events_state.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/profiles/infrastructure/service/resident_api_service.dart';

import '../../../../shared/exceptions/session_expired_exception.dart';

/// BLoC for managing tank events state and business logic.
/// 
/// This BLoC handles all tank events-related operations including fetching,
/// searching, and refreshing tank events data. It coordinates between the
/// presentation layer and the business logic layer, managing the complete
/// lifecycle of tank events data.
/// 
/// The BLoC follows the BLoC pattern for state management and provides:
/// - Data fetching from multiple data sources
/// - Search functionality with real-time filtering
/// - Error handling and state management
/// - Authentication and resident validation
class TankEventsBloc extends Bloc<TankEventsEvent, TankEventsState> {
  final DeviceUseCase _deviceUseCase;
  
  final SecureStorageService _secureStorage;
  
  final ResidentApiService _residentApiService;
  
  List<Event> _allEvents = [];
  int _currentDeviceId = 1; // Store the current deviceId

  TankEventsBloc({
    required DeviceUseCase deviceUseCase,
    required SecureStorageService secureStorage,
    required ResidentApiService residentApiService,
  }) : _deviceUseCase = deviceUseCase,
       _secureStorage = secureStorage,
       _residentApiService = residentApiService,
       super(InitialTankEventsState()) {
    
    // Register event handlers
    on<FetchTankEventsEvent>(_onFetchTankEvents);
    on<SearchTankEventsEvent>(_onSearchTankEvents);
    on<RefreshTankEventsEvent>(_onRefreshTankEvents);
  }

  /// Handles the fetch tank events event.
  /// 
  /// This method performs the complete data fetching process:
  /// 1. Retrieves authentication token
  /// 2. Validates resident information
  /// 3. Retrieves events directly from the device using device ID
  /// 4. Updates the internal cache and emits loaded state
  /// 
  /// Parameters:
  /// - [event]: The fetch tank events event
  /// - [emit]: The state emitter
  /// 
  /// Throws:
  /// - Exception when authentication token is missing
  /// - Exception when resident is not found
  /// - Exception when no events are available
  Future<void> _onFetchTankEvents(FetchTankEventsEvent event, Emitter<TankEventsState> emit) async {
    emit(TankEventsLoadingState());
    
    try {
      final token = await _secureStorage.getToken();
      if (token == null) throw Exception('No authentication token found');
      
      final residentJson = await _residentApiService.getResident(token);
      if (residentJson == null || residentJson['id'] == null) {
        throw Exception('Resident not found');
      }
      
      final deviceId = event.deviceId ?? 1;
      _currentDeviceId = deviceId; // Store the current deviceId
      final events = await _deviceUseCase.getEventsByDeviceId(token, deviceId);
      
      if (events.isEmpty) throw Exception('No events found for device');
      
      _allEvents = events;
      emit(TankEventsLoadedState(events: events));
      
    } on SessionExpiredException {
      emit(TankEventsSessionExpiredState());
    } catch (e) {
      emit(TankEventsErrorState(e.toString()));
    }
  }

  /// Handles the search tank events event.
  /// 
  /// This method updates the search query in the current state
  /// if the BLoC is in a loaded state, enabling real-time filtering
  /// of the events list.
  /// 
  /// Parameters:
  /// - [event]: The search tank events event containing the query
  /// - [emit]: The state emitter
  Future<void> _onSearchTankEvents(SearchTankEventsEvent event, Emitter<TankEventsState> emit) async {
    if (state is TankEventsLoadedState) {
      emit(TankEventsLoadedState(events: _allEvents, searchQuery: event.query));
    }
  }

  /// Handles the refresh tank events event.
  /// 
  /// This method triggers a complete refresh of the tank events data
  /// by re-fetching from the data source, typically used for
  /// pull-to-refresh functionality.
  /// 
  /// Parameters:
  /// - [event]: The refresh tank events event
  /// - [emit]: The state emitter
  Future<void> _onRefreshTankEvents(RefreshTankEventsEvent event, Emitter<TankEventsState> emit) async {
    await _onFetchTankEvents(FetchTankEventsEvent(deviceId: _currentDeviceId), emit);
  }
} 