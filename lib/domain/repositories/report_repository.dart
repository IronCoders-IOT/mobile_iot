import 'package:mobile_iot/domain/entities/report.dart';

abstract class ReportRepository {
  Future<void> createReport(String token, String tittle, String description, String status);
  Future<List<Report>> getReportByResidentId(String token, int residentId);

}