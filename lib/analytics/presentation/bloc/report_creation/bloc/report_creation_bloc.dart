import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/analytics/application/report_use_case.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/profiles/infrastructure/service/resident_api_service.dart';
import 'report_creation_event.dart';
import 'report_creation_state.dart';

/// BLoC for managing report creation state and logic
class ReportCreationBloc extends Bloc<ReportCreationEvent, ReportCreationState> {
  final ReportUseCase reportUseCase;
  final SecureStorageService secureStorage;
  final ResidentApiService residentApiService;

  ReportCreationBloc({
    required this.reportUseCase,
    required this.secureStorage,
    required this.residentApiService,
  }) : super(ReportCreationInitialState()) {
    on<CreateReportEvent>(_onCreateReport);
  }

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