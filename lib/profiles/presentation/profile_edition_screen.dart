import 'package:flutter/material.dart';
import 'package:mobile_iot/profiles/application/profile_use_case.dart';
import 'package:mobile_iot/profiles/domain/entities/profile.dart';
import 'package:mobile_iot/profiles/infrastructure/service/profile_api_service.dart';
import 'package:mobile_iot/profiles/infrastructure/repositories/profile_repository_impl.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';
import 'package:mobile_iot/shared/widgets/back_header.dart';
import 'package:mobile_iot/profiles/presentation/widgets/profile_avatar.dart';
import 'package:mobile_iot/profiles/presentation/widgets/profile_edit_field.dart';
import 'package:mobile_iot/shared/widgets/app_button.dart';
class ProfileEditionScreen extends StatefulWidget {
  const ProfileEditionScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditionScreen> createState() => _ProfileEditionScreenState();
}

class _ProfileEditionScreenState extends State<ProfileEditionScreen> {

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _directionController;
  late TextEditingController _documentNumberController;
  late TextEditingController _documentTypeController;
  late TextEditingController _phoneController;
  late SecureStorageService _secureStorage;
  late ProfileUseCase _profileUseCase;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeServices();
  }

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

  void _initializeServices() {
    _secureStorage = SecureStorageService();
    final repository = ProfileRepositoryImpl(ProfileApiService());
    _profileUseCase = ProfileUseCase(repository);
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final token = await _secureStorage.getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }
    try {

      final profile = await _profileUseCase.getProfile(token);
      if (profile != null) {
        setState(() {
          _firstNameController.text = profile.firstName;
          _lastNameController.text = profile.lastName;
          _emailController.text = profile.email;
          _documentNumberController.text = profile.documentNumber;
          _documentTypeController.text = profile.documentType;
          _phoneController.text = profile.phone;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading profile: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
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

  Future<void> _handleSaveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isLoading = true;
        });

        final token = await _secureStorage.getToken();
        if (token == null) {
          throw Exception('No authentication token found');
        }

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

        await _profileUseCase.updateProfile(token,updatedProfile);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: AppColors.green,
            ),
          );
          Navigator.pop(context, updatedProfile);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating profile: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Column(
                  children: [
          BackHeader(title: 'Edit Profile'),

          Expanded(
            child: SingleChildScrollView(
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
            ),
          ),
        ],
        ),
      ),
    );
  }



  Widget _buildAvatarSection() {
    return ProfileAvatar(
      showCameraIcon: true,
      onCameraTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo upload coming soon!'),
            backgroundColor: AppColors.primaryBlue,
          ),
        );
      },
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ProfileEditField(
            label: 'First Name',
            controller: _firstNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ProfileEditField(
            label: 'Last Name',
            controller: _lastNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ProfileEditField(
            label: 'Username',
            controller: _usernameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ProfileEditField(
            label: 'Email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ProfileEditField(
            label: 'Document',
            controller: _documentNumberController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your document number';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ProfileEditField(
            label: 'Phone Number',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }



  Widget _buildSaveButton() {
    return AppButton(
      text: 'Save changes',
      onPressed: _isLoading ? null : _handleSaveChanges,
      isLoading: _isLoading,
    );
  }
}
