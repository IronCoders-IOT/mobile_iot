import 'package:mobile_iot/analytics/domain/repositories/report_repository.dart';
import 'package:mobile_iot/analytics/domain/entities/report.dart';

class ReportUseCase{
  final ReportRepository reportRepository;
  ReportUseCase(this.reportRepository);
  Future<void> createReport(String token, String title, String description, String status) {
    return reportRepository.createReport(token, title, description, status);
  }
  Future<List<Report>> getReportByResidentId(String token, int residentId) {
    return reportRepository.getReportByResidentId(token, residentId);
  }
}