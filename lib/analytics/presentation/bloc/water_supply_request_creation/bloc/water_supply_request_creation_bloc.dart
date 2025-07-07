import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/analytics/infrastructure/repositories/water_request_repository_impl.dart';
import 'package:mobile_iot/analytics/infrastructure/service/water_request_api_service.dart';
import 'package:mobile_iot/analytics/domain/logic/water_request_validator.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'water_supply_request_creation_event.dart';
import 'water_supply_request_creation_state.dart';

/// BLoC for managing water supply request creation state and logic
class WaterSupplyRequestCreationBloc extends Bloc<WaterSupplyRequestCreationEvent, WaterSupplyRequestCreationState> {
  final WaterRequestRepositoryImpl repository;
  final SecureStorageService secureStorage;

  WaterSupplyRequestCreationBloc({
    required this.repository,
    required this.secureStorage,
  }) : super(WaterSupplyRequestCreationInitialState()) {
    on<CreateWaterSupplyRequestEvent>(_onCreateWaterSupplyRequest);
  }

  Future<void> _onCreateWaterSupplyRequest(
    CreateWaterSupplyRequestEvent event,
    Emitter<WaterSupplyRequestCreationState> emit,
  ) async {
    // Validate input
    final validationError = WaterRequestValidator.validateLiters(event.liters);
    if (validationError != null) {
      emit(WaterSupplyRequestCreationErrorState(validationError));
      return;
    }

    emit(WaterSupplyRequestCreationLoadingState());
    
    try {
      final token = await secureStorage.getToken();
      if (token == null) throw Exception('No authentication token found');
      
      final liters = int.parse(event.liters);
      await repository.createWaterRequest(
        token,
        event.liters,
        'IN_PROGRESS',
        DateTime.now().toIso8601String(),
      );
      
      emit(WaterSupplyRequestCreationSuccessState(liters));
    } catch (e) {
      emit(WaterSupplyRequestCreationErrorState('Failed to send request: ${e.toString()}'));
    }
  }
} 