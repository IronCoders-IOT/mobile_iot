import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/profiles/application/resident_use_case.dart';
import 'package:mobile_iot/profiles/infrastructure/repositories/resident_repository_impl.dart';
import 'package:mobile_iot/profiles/infrastructure/service/resident_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/repositories/water_request_repository_impl.dart';
import 'package:mobile_iot/analytics/infrastructure/service/water_request_api_service.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/shared/exceptions/session_expired_exception.dart';
import 'water_supply_request_event.dart';
import 'water_supply_request_state.dart';

/// BLoC for managing water supply request state and logic
class WaterSupplyRequestBloc extends Bloc<WaterSupplyRequestEvent, WaterSupplyRequestState> {
  final ResidentUseCase residentUseCase;
  final WaterRequestRepositoryImpl waterRequestRepo;
  final SecureStorageService secureStorage;

  WaterSupplyRequestBloc({
    required this.residentUseCase,
    required this.waterRequestRepo,
    required this.secureStorage,
  }) : super(WaterSupplyRequestInitialState()) {
    on<FetchWaterSupplyRequestsEvent>(_onFetchWaterSupplyRequests);
    on<RefreshWaterSupplyRequestsEvent>(_onRefreshWaterSupplyRequests);
  }

  Future<void> _onFetchWaterSupplyRequests(
    FetchWaterSupplyRequestsEvent event,
    Emitter<WaterSupplyRequestState> emit,
  ) async {
    await _fetchRequests(emit);
  }

  Future<void> _onRefreshWaterSupplyRequests(
    RefreshWaterSupplyRequestsEvent event,
    Emitter<WaterSupplyRequestState> emit,
  ) async {
    await _fetchRequests(emit);
  }

  Future<void> _fetchRequests(Emitter<WaterSupplyRequestState> emit) async {
    emit(WaterSupplyRequestLoadingState());
    
    try {
      final token = await secureStorage.getToken();
      if (token == null) throw Exception('No authentication token found');
      
      final profile = await residentUseCase.getProfile(token);
      if (profile == null) throw Exception('Could not load profile');
      
      final residentId = profile.id;
      if (residentId == null) throw Exception('Resident ID not found in profile');
      
      final requests = await waterRequestRepo.getAllRequestsByResidentId(token, residentId);
      emit(WaterSupplyRequestLoadedState(requests));
    } on SessionExpiredException catch (e) {
      await secureStorage.deleteToken();
      emit(WaterSupplyRequestErrorState(e.message));
    } catch (e) {
      emit(WaterSupplyRequestErrorState(e.toString()));
    }
  }
} 