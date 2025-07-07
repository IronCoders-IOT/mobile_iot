import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/analytics/application/report_use_case.dart';
import 'package:mobile_iot/analytics/domain/entities/report.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/profiles/infrastructure/service/resident_api_service.dart';
import 'package:mobile_iot/shared/exceptions/session_expired_exception.dart';
import './bloc.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final ReportUseCase _reportUseCase;
  final SecureStorageService _secureStorage;
  final ResidentApiService _residentApiService;
  
  List<Report> _allReports = [];

  ReportsBloc({
    required ReportUseCase reportUseCase,
    required SecureStorageService secureStorage,
    required ResidentApiService residentApiService,
  }) : _reportUseCase = reportUseCase,
       _secureStorage = secureStorage,
       _residentApiService = residentApiService,
       super(InitialReportsState()) {
    
    on<FetchReportsEvent>(_onFetchReports);
    on<SearchReportsEvent>(_onSearchReports);
    on<RefreshReportsEvent>(_onRefreshReports);
  }

  Future<void> _onFetchReports(FetchReportsEvent event, Emitter<ReportsState> emit) async {
    emit(ReportsLoadingState());
    
    try {
      final token = await _secureStorage.getToken();
      if (token == null) throw Exception('No authentication token found');
      
      final residentJson = await _residentApiService.getResident(token);
      if (residentJson == null || residentJson['id'] == null) {
        throw Exception('Resident not found');
      }
      
      final residentId = residentJson['id'];
      final reports = await _reportUseCase.getReportByResidentId(token, residentId);
      
      _allReports = reports;
      emit(ReportsLoadedState(reports: reports));
      
    } on SessionExpiredException catch (e) {
      await _secureStorage.deleteToken();
      emit(ReportsErrorState(e.message));
    } catch (e) {
      emit(ReportsErrorState(e.toString()));
    }
  }

  Future<void> _onSearchReports(SearchReportsEvent event, Emitter<ReportsState> emit) async {
    if (state is ReportsLoadedState) {
      emit(ReportsLoadedState(reports: _allReports, searchQuery: event.query));
    }
  }

  Future<void> _onRefreshReports(RefreshReportsEvent event, Emitter<ReportsState> emit) async {
    await _onFetchReports(FetchReportsEvent(), emit);
  }
} 