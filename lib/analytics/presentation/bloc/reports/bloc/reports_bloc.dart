import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/analytics/application/report_use_case.dart';
import 'package:mobile_iot/analytics/domain/entities/report.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/profiles/infrastructure/service/resident_api_service.dart';
import 'package:mobile_iot/shared/exceptions/session_expired_exception.dart';
import './bloc.dart';

/// BLoC for managing reports state and business logic.
/// 
/// This BLoC handles all reports-related operations including fetching,
/// searching, and refreshing reports data. It coordinates between the
/// presentation layer and the business logic layer, managing the complete
/// lifecycle of reports data.
/// 
/// The BLoC follows the BLoC pattern for state management and provides:
/// - Data fetching from the reports data source
/// - Search functionality with real-time filtering
/// - Error handling and state management
/// - Authentication and session management
/// - Resident validation
class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  /// Use case for report-related operations.
  final ReportUseCase _reportUseCase;
  
  /// Service for secure storage operations (authentication tokens).
  final SecureStorageService _secureStorage;
  
  /// Service for resident API operations.
  final ResidentApiService _residentApiService;
  
  /// Internal cache of all reports for search functionality.
  List<Report> _allReports = [];

  /// Creates a reports BLoC with the required dependencies.
  /// 
  /// Parameters:
  /// - [reportUseCase]: Use case for report operations
  /// - [secureStorage]: Service for secure storage
  /// - [residentApiService]: Service for resident API operations
  ReportsBloc({
    required ReportUseCase reportUseCase,
    required SecureStorageService secureStorage,
    required ResidentApiService residentApiService,
  }) : _reportUseCase = reportUseCase,
       _secureStorage = secureStorage,
       _residentApiService = residentApiService,
       super(InitialReportsState()) {
    
    // Register event handlers
    on<FetchReportsEvent>(_onFetchReports);
    on<SearchReportsEvent>(_onSearchReports);
    on<RefreshReportsEvent>(_onRefreshReports);
  }

  /// Handles the fetch reports event.
  /// 
  /// This method performs the complete data fetching process:
  /// 1. Retrieves authentication token
  /// 2. Validates resident information
  /// 3. Fetches reports for the authenticated resident
  /// 4. Updates the internal cache and emits loaded state
  /// 
  /// Parameters:
  /// - [event]: The fetch reports event
  /// - [emit]: The state emitter
  /// 
  /// Throws:
  /// - Exception when authentication token is missing
  /// - Exception when resident is not found
  /// - SessionExpiredException when the session has expired
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

  /// Handles the search reports event.
  /// 
  /// This method updates the search query in the current state
  /// if the BLoC is in a loaded state, enabling real-time filtering
  /// of the reports list.
  /// 
  /// Parameters:
  /// - [event]: The search reports event containing the query
  /// - [emit]: The state emitter
  Future<void> _onSearchReports(SearchReportsEvent event, Emitter<ReportsState> emit) async {
    if (state is ReportsLoadedState) {
      emit(ReportsLoadedState(reports: _allReports, searchQuery: event.query));
    }
  }

  /// Handles the refresh reports event.
  /// 
  /// This method triggers a complete refresh of the reports data
  /// by re-fetching from the data source, typically used for
  /// pull-to-refresh functionality.
  /// 
  /// Parameters:
  /// - [event]: The refresh reports event
  /// - [emit]: The state emitter
  Future<void> _onRefreshReports(RefreshReportsEvent event, Emitter<ReportsState> emit) async {
    await _onFetchReports(FetchReportsEvent(), emit);
  }
} 