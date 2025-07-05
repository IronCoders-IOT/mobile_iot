import 'package:flutter/material.dart';
import 'package:mobile_iot/profiles/application/profile_use_case.dart';
import 'package:mobile_iot/profiles/domain/entities/profile.dart';
import 'package:mobile_iot/profiles/infrastructure/service/profile_api_service.dart';
import 'package:mobile_iot/profiles/infrastructure/repositories/profile_repository_impl.dart';
import 'package:mobile_iot/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';
import 'package:mobile_iot/profiles/presentation/widgets/profile_header.dart';
import 'package:mobile_iot/profiles/presentation/widgets/profile_avatar.dart';
import 'package:mobile_iot/profiles/presentation/widgets/profile_field_display.dart';

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
            ProfileHeader(
              onLogout: _handleLogout,
              onEdit: () async {
                final result = await Navigator.pushNamed(context, '/edit-profile');
                if (result != null && result is Profile) {
                  setState(() {
                    _profile = result;
                  });
                }
              },
            ),
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



  Widget _buildProfileHeader() {
    return Column(
      children: [
        ProfileAvatar(),
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
        ProfileFieldDisplay(
          label: 'First Name',
          value: _profile!.firstName,
        ),
        const SizedBox(height: 24),
        ProfileFieldDisplay(
          label: 'Last Name',
          value: _profile!.lastName,
        ),
        const SizedBox(height: 24),
        ProfileFieldDisplay(
          label: 'Email',
          value: _profile!.email,
        ),
        const SizedBox(height: 24),
        ProfileFieldDisplay(
          label: 'Document',
          value: _profile!.documentNumber,
        ),
        const SizedBox(height: 24),
        ProfileFieldDisplay(
          label: 'Phone Number',
          value: _profile!.phone,
        ),
      ],
    );
  }


}
