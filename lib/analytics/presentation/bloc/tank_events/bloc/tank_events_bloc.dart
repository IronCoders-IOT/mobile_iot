import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/analytics/application/device_use_case.dart';
import 'package:mobile_iot/analytics/application/event_use_case.dart';
import 'package:mobile_iot/analytics/domain/entities/event.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/profiles/infrastructure/service/resident_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/service/device_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/service/event_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/repositories/device_repository_impl.dart';
import 'package:mobile_iot/analytics/infrastructure/repositories/event_repository_impl.dart';
import './bloc.dart';

class TankEventsBloc extends Bloc<TankEventsEvent, TankEventsState> {
  final DeviceUseCase _deviceUseCase;
  final EventUseCase _eventUseCase;
  final SecureStorageService _secureStorage;
  final ResidentApiService _residentApiService;
  
  List<Event> _allEvents = [];

  TankEventsBloc({
    required DeviceUseCase deviceUseCase,
    required EventUseCase eventUseCase,
    required SecureStorageService secureStorage,
    required ResidentApiService residentApiService,
  }) : _deviceUseCase = deviceUseCase,
       _eventUseCase = eventUseCase,
       _secureStorage = secureStorage,
       _residentApiService = residentApiService,
       super(InitialTankEventsState()) {
    
    on<FetchTankEventsEvent>(_onFetchTankEvents);
    on<SearchTankEventsEvent>(_onSearchTankEvents);
    on<RefreshTankEventsEvent>(_onRefreshTankEvents);
  }

  Future<void> _onFetchTankEvents(FetchTankEventsEvent event, Emitter<TankEventsState> emit) async {
    emit(TankEventsLoadingState());
    
    try {
      final token = await _secureStorage.getToken();
      if (token == null) throw Exception('No authentication token found');
      
      final residentJson = await _residentApiService.getResident(token);
      if (residentJson == null || residentJson['id'] == null) {
        throw Exception('Resident not found');
      }
      
      final residentId = residentJson['id'] as int;
      final sensors = await _deviceUseCase.getDevice(token, residentId);
      if (sensors.isEmpty) throw Exception('No sensors found for resident');
      
      final sensorId = sensors.first.id;
      final events = await _eventUseCase.getAllEventsBySensorId(token, sensorId);
      
      _allEvents = events;
      emit(TankEventsLoadedState(events: events));
      
    } catch (e) {
      emit(TankEventsErrorState(e.toString()));
    }
  }

  Future<void> _onSearchTankEvents(SearchTankEventsEvent event, Emitter<TankEventsState> emit) async {
    if (state is TankEventsLoadedState) {
      emit(TankEventsLoadedState(events: _allEvents, searchQuery: event.query));
    }
  }

  Future<void> _onRefreshTankEvents(RefreshTankEventsEvent event, Emitter<TankEventsState> emit) async {
    await _onFetchTankEvents(FetchTankEventsEvent(), emit);
  }
} 