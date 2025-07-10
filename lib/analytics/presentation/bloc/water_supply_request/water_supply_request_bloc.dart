import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/analytics/presentation/bloc/water_supply_request/water_supply_request_event.dart';
import 'package:mobile_iot/analytics/presentation/bloc/water_supply_request/water_supply_request_state.dart';
import 'package:mobile_iot/profiles/application/resident_use_case.dart';
import 'package:mobile_iot/analytics/infrastructure/repositories/water_request_repository_impl.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/shared/exceptions/session_expired_exception.dart';


/// BLoC for managing water supply request state and business logic.
/// 
/// This BLoC handles all water supply request-related operations including
/// fetching and refreshing water supply requests data. It coordinates between
/// the presentation layer and the business logic layer, managing the complete
/// lifecycle of water supply request data.
/// 
/// The BLoC follows the BLoC pattern for state management and provides:
/// - Data fetching from the water supply requests data source
/// - Error handling and state management
/// - Authentication and session management
/// - Resident profile validation
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

  /// Handles the fetch water supply requests event.
  /// 
  /// This method delegates to the common fetch method to retrieve
  /// water supply requests data from the data source.
  /// 
  /// Parameters:
  /// - [event]: The fetch water supply requests event
  /// - [emit]: The state emitter
  Future<void> _onFetchWaterSupplyRequests(
    FetchWaterSupplyRequestsEvent event,
    Emitter<WaterSupplyRequestState> emit,
  ) async {
    await _fetchRequests(emit);
  }

  /// Handles the refresh water supply requests event.
  /// 
  /// This method delegates to the common fetch method to refresh
  /// water supply requests data from the data source.
  /// 
  /// Parameters:
  /// - [event]: The refresh water supply requests event
  /// - [emit]: The state emitter
  Future<void> _onRefreshWaterSupplyRequests(
    RefreshWaterSupplyRequestsEvent event,
    Emitter<WaterSupplyRequestState> emit,
  ) async {
    await _fetchRequests(emit);
  }

  /// Common method to fetch water supply requests data.
  /// 
  /// This method performs the complete data fetching process:
  /// 1. Retrieves authentication token
  /// 2. Validates resident profile information
  /// 3. Fetches water supply requests for the authenticated resident
  /// 4. Emits loaded or error state based on the result
  /// 
  /// Parameters:
  /// - [emit]: The state emitter
  /// 
  /// Throws:
  /// - Exception when authentication token is missing
  /// - Exception when profile cannot be loaded
  /// - Exception when resident ID is not found
  /// - SessionExpiredException when the session has expired
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
      emit(WaterSupplyRequestSessionExpiredState());
    } catch (e) {
      emit(WaterSupplyRequestErrorState(e.toString()));
    }
  }
} 