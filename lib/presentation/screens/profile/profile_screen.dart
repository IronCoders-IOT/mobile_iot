import 'package:flutter/material.dart';
import 'package:mobile_iot/application/use_cases/profile_use_case.dart';
import 'package:mobile_iot/core/services/secure_storage_service.dart';
import 'package:mobile_iot/domain/entities/profile.dart';
import 'package:mobile_iot/infrastructure/data_sources/profile_api_service.dart';
import 'package:mobile_iot/infrastructure/repositories/profile_repository_impl.dart';
import 'package:mobile_iot/presentation/widgets/app_bottom_navigation_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileUseCase _profileUseCase;
  late SecureStorageService _secureStorage;
  Profile? _profile;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  void _initializeProfile() {
    _secureStorage = SecureStorageService();
    final repository = ProfileRepositoryImpl(ProfileApiService());
    _profileUseCase = ProfileUseCase(repository);
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final token = await _secureStorage.getToken();
      if (token == null) {
        throw Exception('No se encontró el token de autenticación');
      }

      final profile = await _profileUseCase.getProfile(token);
      
      if (profile == null) {
        throw Exception('No se pudo cargar el perfil');
      }
      
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      
      // Si el error es de autenticación, redirigir al login
      if (e.toString().contains('Sesión expirada')) {
        // Esperar un momento para mostrar el mensaje de error
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    }
  }
  void _handleLogout() async{
    try {
      await _secureStorage.deleteToken();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully'),
            backgroundColor: AppColors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error logging out'),
            backgroundColor: Colors.red,
          ),
        );
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
            _buildHeader(context),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _error!,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchProfile,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              _buildProfileHeader(),
                              const SizedBox(height: 40),
                              _buildProfileFields(),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/reports');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case 2:
              // Already on profile
              break;
          }
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Aqua',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    TextSpan(
                      text: 'Conecta',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _handleLogout,
            child: const Icon(
              Icons.logout,
              color: AppColors.darkBlue,
              size: 24,
            ),
          ),

          GestureDetector(
            onTap: () async {
              final result = await Navigator.pushNamed(context, '/edit-profile');
              if (result != null && result is Profile) {
                setState(() {
                  _profile = result;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.mediumGray.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            size: 50,
            color: AppColors.mediumGray.withOpacity(0.7),
          ),
        ),
        
        const SizedBox(height: 16),
        
        Text(
          _profile?.firstName ?? 'Loading...',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.darkBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileFields() {
    if (_profile == null) return const SizedBox.shrink();

    return Column(
      children: [
        _buildProfileField(
          label: 'First Name',
          value: _profile!.firstName,
        ),
        
        const SizedBox(height: 24),
        
        _buildProfileField(
          label: 'Last Name',
          value: _profile!.lastName,
        ),
        
        const SizedBox(height: 24),
        
        _buildProfileField(
          label: 'Email',
          value: _profile!.email,
        ),
        
        const SizedBox(height: 24),
        
        _buildProfileField(
          label: 'Document',
          value: _profile!.documentNumber,
        ),
        
        const SizedBox(height: 24),
        
        _buildProfileField(
          label: 'Phone Number',
          value: _profile!.phone,
        ),
      ],
    );
  }

  Widget _buildProfileField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.mediumGray.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.darkBlue,
            ),
          ),
        ),
      ],
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

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
            _buildHeader(context),
            
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.darkBlue,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 16),
          
          const Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.mediumGray.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            size: 50,
            color: AppColors.mediumGray.withOpacity(0.7),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Photo upload coming soon!'),
                  backgroundColor: AppColors.primaryBlue,
                ),
              );
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: AppColors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildEditField(
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
          
          _buildEditField(
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
          
          _buildEditField(
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
          
          _buildEditField(
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
          
          _buildEditField(
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
          
          _buildEditField(
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

  Widget _buildEditField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSaveChanges,
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
            : const Text('Save changes'),
      ),
    );
  }
}

class AppColors {
  static const Color primaryBlue = Color(0xFF3498DB);
  static const Color darkBlue = Color(0xFF2C3E50);
  static const Color lightGray = Color(0xFFF8F9FA);
  static const Color mediumGray = Color(0xFF6C757D);
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF28A745);
}