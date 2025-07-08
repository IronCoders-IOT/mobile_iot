import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/analytics/infrastructure/repositories/water_request_repository_impl.dart';
import 'package:mobile_iot/analytics/infrastructure/service/water_request_api_service.dart';
import 'package:mobile_iot/analytics/domain/logic/water_request_validator.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'water_supply_request_creation_event.dart';
import 'water_supply_request_creation_state.dart';

/// BLoC for managing water supply request creation state and business logic.
/// 
/// This BLoC handles the water supply request creation process, coordinating between
/// the presentation layer and the business logic layer. It manages the complete
/// lifecycle of water supply request creation including validation, submission,
/// and error handling.
/// 
/// The BLoC follows the BLoC pattern for state management and provides:
/// - Input validation using WaterRequestValidator
/// - Water supply request creation with authentication
/// - Error handling and state management
/// - Loading states for user feedback
class WaterSupplyRequestCreationBloc extends Bloc<WaterSupplyRequestCreationEvent, WaterSupplyRequestCreationState> {
  /// Repository for water request data operations.
  final WaterRequestRepositoryImpl repository;
  
  /// Service for secure storage operations (authentication tokens).
  final SecureStorageService secureStorage;

  /// Creates a water supply request creation BLoC with the required dependencies.
  /// 
  /// Parameters:
  /// - [repository]: Repository for water request operations
  /// - [secureStorage]: Service for secure storage
  WaterSupplyRequestCreationBloc({
    required this.repository,
    required this.secureStorage,
  }) : super(WaterSupplyRequestCreationInitialState()) {
    // Register event handlers
    on<CreateWaterSupplyRequestEvent>(_onCreateWaterSupplyRequest);
  }

  /// Handles the create water supply request event.
  /// 
  /// This method performs the complete water supply request creation process:
  /// 1. Validates the input using WaterRequestValidator
  /// 2. Retrieves authentication token
  /// 3. Creates the water supply request with current timestamp
  /// 4. Emits success or error state based on the result
  /// 
  /// Parameters:
  /// - [event]: The create water supply request event containing liters
  /// - [emit]: The state emitter
  /// 
  /// Throws:
  /// - Exception when authentication token is missing
  /// - Exception when request creation fails
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