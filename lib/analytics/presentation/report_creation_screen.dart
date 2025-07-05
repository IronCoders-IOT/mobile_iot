import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/profiles/infrastructure/service/resident_api_service.dart';
import 'package:mobile_iot/analytics/application/report_use_case.dart';
import 'package:mobile_iot/analytics/infrastructure/repositories/report_repository_impl.dart';
import 'package:mobile_iot/analytics/infrastructure/service/report_api_service.dart';
import 'package:mobile_iot/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_header.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_error_state.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_loading_state.dart';

import '../../shared/widgets/app_colors.dart';

class ReportCreationScreen extends StatefulWidget {
  const ReportCreationScreen({Key? key}) : super(key: key);

  @override
  State<ReportCreationScreen> createState() => _ReportCreationScreenState();
}

class _ReportCreationScreenState extends State<ReportCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final storage = SecureStorageService();
      final token = await storage.getToken();
      if (token == null) throw Exception('No authentication token found');
      final residentJson = await ResidentApiService().getResident(token);
      if (residentJson == null || residentJson['id'] == null) throw Exception('Resident not found');
      final reportUseCase = ReportUseCase(ReportRepositoryImpl(ReportApiService()));
      await reportUseCase.createReport(
        token,
        _titleController.text.trim(),
        _descriptionController.text.trim(),
        'IN_PROGRESS', // Default status for new reports
      );
      if (!mounted) return;
      Navigator.pop(context, true); // Optionally return success
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'New Report',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Create Report',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          hintText: 'Enter report title',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Describe the issue...',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      if (_error != null)
                        AppErrorState(
                          message: _error!,
                          onRetry: _handleSubmit,
                        ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                                  ),
                                )
                              : const Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/reports');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}

