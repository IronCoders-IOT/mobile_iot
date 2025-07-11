import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/profiles/infrastructure/service/resident_api_service.dart';
import 'package:mobile_iot/analytics/application/report_use_case.dart';
import 'package:mobile_iot/analytics/infrastructure/repositories/report_repository_impl.dart';
import 'package:mobile_iot/analytics/infrastructure/service/report_api_service.dart';
import 'package:mobile_iot/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_header.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_error_state.dart';
import 'package:mobile_iot/analytics/presentation/widgets/app_loading_state.dart';
import 'package:mobile_iot/analytics/presentation/bloc/report_creation/bloc.dart';
import '../../l10n/app_localizations.dart';

import '../../shared/widgets/app_colors.dart';
import 'bloc/report_creation/report_creation_bloc.dart';
import 'bloc/report_creation/report_creation_event.dart';
import '../../shared/widgets/session_expired_screen.dart';

/// A screen for creating new reports with BLoC state management.
/// 
/// The screen automatically handles:
/// - Form validation and error display
/// - Loading states while creating reports
/// - Error states with retry functionality
/// - Success states with automatic navigation
/// - Authentication token validation
/// - Resident verification
class ReportCreationScreen extends StatelessWidget {
  /// Creates a report creation screen.
  /// 
  /// The [key] parameter is optional and is passed to the superclass.
  const ReportCreationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReportCreationBloc>(
      create: (context) => ReportCreationBloc(
        reportUseCase: ReportUseCase(ReportRepositoryImpl(
          reportApiService: ReportApiService(),
          residentApiService: ResidentApiService(),
        )),
        secureStorage: SecureStorageService(),
        residentApiService: ResidentApiService(),
      ),
      child: BlocConsumer<ReportCreationBloc, ReportCreationState>(
        listener: (context, state) {
          if (state is ReportCreationSessionExpiredState) {
            Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
          }
          if (state is ReportCreationSuccessState) {
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          if (state is ReportCreationSessionExpiredState) {
            return SessionExpiredScreen(
              onLoginAgain: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              },
            );
          }
          return Scaffold(
            backgroundColor: AppColors.lightGray,
            body: SafeArea(
              child: Column(
                children: [
                  AppHeader(
                    title: AppLocalizations.of(context)!.newReport,
                    onBack: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: state is ReportCreationLoadingState
                        ? const AppLoadingState()
                        : _buildForm(context, state),
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
        },
      ),
    );
  }

  /// Builds the report creation form with validation and error handling.
  /// 
  /// This method creates a form with:
  /// - Title input field with validation
  /// - Description input field with validation
  /// - Error state display when creation fails
  /// - Submit button for creating the report
  /// - Proper styling and layout
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// - [state]: The current state from the ReportCreationBloc
  /// 
  /// Returns a widget containing the complete report creation form.
  Widget _buildForm(BuildContext context, ReportCreationState state) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.createReport,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.title,
                hintText: AppLocalizations.of(context)!.enterReportTitle,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.pleaseEnterTitle;
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.description,
                hintText: AppLocalizations.of(context)!.describeTheIssue,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.pleaseEnterDescription;
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            if (state is ReportCreationErrorState)
              AppErrorState(
                message: state.message,
                onRetry: () => _handleSubmit(context, formKey, titleController, descriptionController),
              ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _handleSubmit(context, formKey, titleController, descriptionController),
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
                child: Text(AppLocalizations.of(context)!.submit),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handles form submission and triggers report creation.
  /// 
  /// This method:
  /// - Validates the form fields
  /// - Creates a CreateReportEvent with form data
  /// - Dispatches the event to the BLoC for processing
  /// - Handles the creation flow through BLoC state management
  /// 
  /// Parameters:
  /// - [context]: The build context for accessing the BLoC
  /// - [formKey]: The form key for validation
  /// - [titleController]: Controller for the title field
  /// - [descriptionController]: Controller for the description field
  void _handleSubmit(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController titleController,
    TextEditingController descriptionController,
  ) {
    if (!formKey.currentState!.validate()) return;
    
    context.read<ReportCreationBloc>().add(
      CreateReportEvent(
        title: titleController.text,
        description: descriptionController.text,
      ),
    );
  }
}

