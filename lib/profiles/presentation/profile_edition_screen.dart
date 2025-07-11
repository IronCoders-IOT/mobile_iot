import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/profiles/application/profile_use_case.dart';
import 'package:mobile_iot/profiles/domain/entities/profile.dart';
import 'package:mobile_iot/profiles/domain/logic/profile_validators.dart';
import 'package:mobile_iot/profiles/infrastructure/service/profile_api_service.dart';
import 'package:mobile_iot/profiles/infrastructure/repositories/profile_repository_impl.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';
import 'package:mobile_iot/shared/widgets/back_header.dart';
import 'package:mobile_iot/profiles/presentation/widgets/profile_avatar.dart';
import 'package:mobile_iot/profiles/presentation/widgets/profile_edit_field.dart';
import 'package:mobile_iot/shared/widgets/app_button.dart';
import 'package:mobile_iot/profiles/presentation/bloc/profile_edition/bloc.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/session_expired_screen.dart';
import '../domain/entities/resident.dart';
import '../infrastructure/service/resident_api_service.dart';
import 'package:mobile_iot/monitoring/presentation/widgets/app_loading_state.dart';
/// A screen that allows users to edit their profile information.
/// 
/// This screen provides a form interface for users to update their profile
/// information including personal details, contact information, and document
/// details. The screen handles form validation, data persistence, and
/// user feedback for successful or failed operations.
/// 
/// Features:
/// - Form-based profile editing with real-time validation
/// - Avatar display with camera icon (placeholder for future photo upload)
/// - Input validation for all profile fields
/// - Loading states during save operations
/// - Error handling and user feedback
/// - Navigation back to profile screen after successful save
///
class ProfileEditionScreen extends StatefulWidget {

  const ProfileEditionScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditionScreen> createState() => _ProfileEditionScreenState();
}

/// The state class for the ProfileEditionScreen widget.
/// 
/// This class manages the form state, text controllers, and validation
/// for the profile edition screen. The business logic is now handled
/// by the ProfileEditionBloc.
class _ProfileEditionScreenState extends State<ProfileEditionScreen> {
  /// Global key for form validation.
  final _formKey = GlobalKey<FormState>();
  
  /// Text controllers for form fields.
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _directionController;
  late TextEditingController _documentNumberController;
  late TextEditingController _documentTypeController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    // Load profile data using BLoC
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileEditionBloc>().add(const LoadProfileEvent());
    });
  }

  /// Initializes all text editing controllers for form fields.
  void _initializeControllers() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _directionController = TextEditingController();
    _documentNumberController = TextEditingController();
    _documentTypeController = TextEditingController();
    _phoneController = TextEditingController();
  }

  /// Populates form fields with profile data from BLoC state.
  /// 
  /// This method updates the text controllers with the profile data
  /// received from the BLoC state. Handles null values by providing
  /// empty strings as defaults.
  void _populateFormFields(Profile profile, {Resident? resident}) {
    _firstNameController.text = profile.firstName ?? '';
    _lastNameController.text = profile.lastName ?? '';
    _emailController.text = profile.email ?? '';
    _directionController.text = profile.direction ?? '';
    _documentNumberController.text = profile.documentNumber ?? '';
    _documentTypeController.text = profile.documentType ?? '';
    _phoneController.text = profile.phone ?? '';
    if (resident != null) {
      _usernameController.text = resident.username ?? '';
    }
  }

  @override
  void dispose() {
    // Clean up text controllers to prevent memory leaks
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _directionController.dispose();
    _documentNumberController.dispose();
    _documentTypeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Handles the save changes operation for the profile form.
  /// 
  /// This method validates the form and dispatches an update event
  /// to the BLoC for processing.
  void _handleSaveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = Profile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        direction: _directionController.text,
        documentNumber: _documentNumberController.text,
        documentType: _documentTypeController.text,
        phone: _phoneController.text,
        userId: 0, // Assuming userId is not editable and remains unchanged
      );

      print('Dispatching UpdateProfileEvent');
      context.read<ProfileEditionBloc>().add(UpdateProfileEvent(profile: updatedProfile));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileEditionBloc, ProfileEditionState>(
      listener: (context, state) {
        if (state is ProfileEditionSessionExpiredState) {
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        }
        if (state is ProfileEditionLoadedState) {
          _populateFormFields(state.profile, resident: state.resident);
        } else if (state is ProfileEditionUpdatedState) {
          print('ProfileEditionUpdatedState reached');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.profileUpdated),
              backgroundColor: AppColors.green,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is ProfileEditionErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileEditionSessionExpiredState) {
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
                BackHeader(title: AppLocalizations.of(context)!.editProfile),
                Expanded(
                  child: _buildBody(state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds the main body content based on the current BLoC state.
  Widget _buildBody(ProfileEditionState state) {
    if (state is ProfileEditionLoadingState) {
      return const AppLoadingState();
    } else if (state is ProfileEditionErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: wawa'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<ProfileEditionBloc>().add(const LoadProfileEvent()),
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildAvatarSection(),
            const SizedBox(height: 32),
            _buildEditForm(),
            const SizedBox(height: 32),
            _buildSaveButton(),
            const SizedBox(height: 20),
          ],
        ),
      );
    }
  }

  /// Builds the avatar section with camera icon for photo upload.
  /// 
  /// This method creates a profile avatar widget with a camera icon
  /// that shows a placeholder message for future photo upload functionality.
  /// 
  /// Returns a ProfileAvatar widget with camera interaction.
  Widget _buildAvatarSection() {
    return ProfileAvatar(
      showCameraIcon: true,
      onCameraTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.photoUploadComingSoon),
            backgroundColor: AppColors.primaryBlue,
          ),
        );
      },
    );
  }

  /// Builds the profile editing form with all input fields.
  /// 
  /// This method creates a form widget containing all profile fields
  /// with appropriate validation using the profile validators from the
  /// domain logic layer. Each field has specific keyboard types and
  /// validation rules.
  /// 
  /// Returns a Form widget with all profile editing fields.
  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ProfileEditField(
            label: AppLocalizations.of(context)!.firstName,
            controller: _firstNameController,
            validator: (value) => validateName(value, AppLocalizations.of(context)!.firstName),
          ),
          const SizedBox(height: 20),
          ProfileEditField(
            label: AppLocalizations.of(context)!.lastName,
            controller: _lastNameController,
            validator: (value) => validateName(value, AppLocalizations.of(context)!.lastName),
          ),
          const SizedBox(height: 20),
          ProfileEditField(
            label: AppLocalizations.of(context)!.username,
            controller: _usernameController,
            validator: validateUsername,
          ),
          const SizedBox(height: 20),
          ProfileEditField(
            label: AppLocalizations.of(context)!.email,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: validateEmail,
          ),
          const SizedBox(height: 20),
          ProfileEditField(
            label: AppLocalizations.of(context)!.document,
            controller: _documentNumberController,
            keyboardType: TextInputType.number,
            validator: validateDocumentNumber,
          ),
          const SizedBox(height: 20),
          ProfileEditField(
            label: AppLocalizations.of(context)!.phoneNumber,
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: validatePhone,
          ),
        ],
      ),
    );
  }

  /// Builds the save button for the profile form.
  /// 
  /// This method creates an AppButton widget that handles the save
  /// operation. The button is disabled during updating states and
  /// shows a loading indicator when processing.
  /// 
  /// Returns an AppButton widget for saving profile changes.
  Widget _buildSaveButton() {
    return BlocBuilder<ProfileEditionBloc, ProfileEditionState>(
      builder: (context, state) {
        final isLoading = state is ProfileEditionUpdatingState;
        return AppButton(
          text: AppLocalizations.of(context)!.saveChanges,
          onPressed: isLoading ? null : _handleSaveChanges,
          isLoading: isLoading,
        );
      },
    );
  }
}
