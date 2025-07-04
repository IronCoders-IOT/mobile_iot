import 'package:mobile_iot/analytics/infrastructure/data_sources/report_api_service.dart';
import 'package:mobile_iot/analytics/domain/entities/report.dart';
import 'package:mobile_iot/analytics/domain/interfaces/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {

 final ReportApiService reportApiService;
 ReportRepositoryImpl(this.reportApiService);
  @override
  Future<String?> createReport(String token, String title, String description, String status) {
    return reportApiService.createReport(token, title, description, status);
  }
  @override
  Future<List<Report>> getReportByResidentId(String token, int residentId) {
    return reportApiService.getReportByResidentId(token, residentId);
  }
}