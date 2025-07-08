import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/analytics/application/report_use_case.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/profiles/infrastructure/service/resident_api_service.dart';
import 'report_creation_event.dart';
import 'report_creation_state.dart';

/// BLoC for managing report creation state and business logic.
/// 
/// This BLoC handles the report creation process, coordinating between
/// the presentation layer and the business logic layer. It manages the
/// complete lifecycle of report creation including validation, submission,
/// and error handling.
/// 
/// The BLoC follows the BLoC pattern for state management and provides:
/// - Report creation with validation
/// - Authentication and resident validation
/// - Error handling and state management
/// - Loading states for user feedback
class ReportCreationBloc extends Bloc<ReportCreationEvent, ReportCreationState> {
  /// Use case for report-related operations.
  final ReportUseCase reportUseCase;
  
  /// Service for secure storage operations (authentication tokens).
  final SecureStorageService secureStorage;
  
  /// Service for resident API operations.
  final ResidentApiService residentApiService;

  /// Creates a report creation BLoC with the required dependencies.
  /// 
  /// Parameters:
  /// - [reportUseCase]: Use case for report operations
  /// - [secureStorage]: Service for secure storage
  /// - [residentApiService]: Service for resident API operations
  ReportCreationBloc({
    required this.reportUseCase,
    required this.secureStorage,
    required this.residentApiService,
  }) : super(ReportCreationInitialState()) {
    // Register event handlers
    on<CreateReportEvent>(_onCreateReport);
  }

  /// Handles the create report event.
  /// 
  /// This method performs the complete report creation process:
  /// 1. Retrieves authentication token
  /// 2. Validates resident information
  /// 3. Creates the report with the provided title and description
  /// 4. Emits success or error state based on the result
  /// 
  /// Parameters:
  /// - [event]: The create report event containing title and description
  /// - [emit]: The state emitter
  /// 
  /// Throws:
  /// - Exception when authentication token is missing
  /// - Exception when resident is not found
  /// - Exception when report creation fails
  Future<void> _onCreateReport(
    CreateReportEvent event,
    Emitter<ReportCreationState> emit,
  ) async {
    emit(ReportCreationLoadingState());
    
    try {
      final token = await secureStorage.getToken();
      if (token == null) throw Exception('No authentication token found');
      
      final residentJson = await residentApiService.getResident(token);
      if (residentJson == null || residentJson['id'] == null) {
        throw Exception('Resident not found');
      }
      
      await reportUseCase.createReport(
        token,
        event.title.trim(),
        event.description.trim(),
        'IN_PROGRESS',
      );
      
      emit(ReportCreationSuccessState());
    } catch (e) {
      emit(ReportCreationErrorState(e.toString()));
    }
  }
} 