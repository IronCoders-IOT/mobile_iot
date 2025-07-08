import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:mobile_iot/profiles/presentation/bloc/profile_view/bloc/bloc.dart';

/// A screen that displays the user's profile information.
/// 
/// This screen uses the BLoC pattern for state management and provides the following features:
/// - Display user profile information (personal details, contact info, document details)
/// - Edit profile functionality with navigation to edit screen
/// - Logout functionality
/// - Pull-to-refresh capability
/// - Navigation to other app sections via bottom navigation
/// 
/// The screen automatically handles:
/// - Loading states while fetching profile data
/// - Error states with retry functionality
/// - Session expiration and automatic logout
/// - Profile updates from edit screen
///
class ProfileScreen extends StatefulWidget {
  /// Creates a profile screen.
  /// 
  /// The [key] parameter is optional and is passed to the superclass.
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

/// The state class for the ProfileScreen widget.
/// 
/// This class manages the logout functionality and profile refresh
/// after editing. The main profile data management is handled by
/// the ProfileViewBloc.
class _ProfileScreenState extends State<ProfileScreen> {
  /// Service for secure storage operations (used for logout).
  late SecureStorageService _secureStorage;

  @override
  void initState() {
    super.initState();
    _secureStorage = SecureStorageService();
  }
  /// Handles the logout operation.
  /// 
  /// This method deletes the authentication token and navigates
  /// to the login screen. It provides user feedback for success
  /// and error cases.
  void _handleLogout() async {
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
    return BlocProvider<ProfileViewBloc>(
      create: (context) => ProfileViewBloc(
        profileUseCase: ProfileUseCase(ProfileRepositoryImpl(ProfileApiService())),
        secureStorage: SecureStorageService(),
      )..add(const LoadProfileViewEvent()),
      child: BlocConsumer<ProfileViewBloc, ProfileViewState>(
        // Listen for state changes to handle side effects (like navigation)
        listener: (context, state) {
          if (state is ProfileViewErrorState && 
              state.message.contains('Session expired')) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        // Build the UI based on the current state
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.lightGray,
            body: SafeArea(
              child: Column(
                children: [
                  // Header with logout and edit functionality
                  ProfileHeader(
                    onLogout: _handleLogout,
                    onEdit: () async {
                      // Navigate to profile edition screen and handle result
                      final result = await Navigator.pushNamed(context, '/edit-profile');
                      if (result != null && result is Profile) {
                        // Refresh profile data after successful editing
                        context.read<ProfileViewBloc>().add(const RefreshProfileViewEvent());
                      }
                    },
                  ),
                  // Main content area with profile information
                  Expanded(
                    child: _buildBody(context, state),
                  ),
                ],
              ),
            ),
            // Bottom navigation bar for app-wide navigation
            bottomNavigationBar: AppBottomNavigationBar(
              currentIndex: 2, // Profile tab is active
              onTap: (index) {
                switch (index) {
                  case 0:
                    Navigator.pushReplacementNamed(context, '/reports');
                    break;
                  case 1:
                    Navigator.pushReplacementNamed(context, '/dashboard');
                    break;
                  case 2:
                    // Already on profile screen
                    break;
                }
              },
            ),
          );
        },
      ),
    );
  }

  /// Builds the main body content based on the current BLoC state.
  /// 
  /// This method handles different UI states:
  /// - [ProfileViewLoadingState]: Shows loading indicator
  /// - [ProfileViewErrorState]: Shows error message with retry button
  /// - [ProfileViewLoadedState]: Shows the profile information
  /// - Default: Shows loading indicator as fallback
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// - [state]: The current state from the ProfileViewBloc
  /// 
  /// Returns a widget that represents the appropriate UI for the current state.
  Widget _buildBody(BuildContext context, ProfileViewState state) {
    if (state is ProfileViewLoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ProfileViewErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<ProfileViewBloc>().add(const LoadProfileViewEvent()),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (state is ProfileViewLoadedState) {
      return RefreshIndicator(
        // Pull-to-refresh functionality to reload profile data
        onRefresh: () async => context.read<ProfileViewBloc>().add(const RefreshProfileViewEvent()),
                  child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile avatar and name section
                _buildProfileHeader(state.profile),
                const SizedBox(height: 40),
                // Profile information fields section
                _buildProfileFields(state.profile),
              ],
            ),
          ),
      );
    }
    
    // Fallback to loading state for unknown states
    return const Center(child: CircularProgressIndicator());
  }



  /// Builds the profile header section with avatar and name.
  /// 
  /// This method creates a column widget that displays the user's
  /// avatar and first name in a centered layout.
  /// 
  /// Parameters:
  /// - [profile]: The profile entity containing user data
  /// 
  /// Returns a column widget with the profile header display.
  Widget _buildProfileHeader(Profile profile) {
    return Column(
      children: [
        ProfileAvatar(),
        const SizedBox(height: 16),
        Text(
          profile.firstName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.darkBlue,
          ),
        ),
      ],
    );
  }

  /// Builds the profile fields section with user information.
  /// 
  /// This method creates a column widget that displays all the
  /// user's profile information using ProfileFieldDisplay widgets.
  /// 
  /// Parameters:
  /// - [profile]: The profile entity containing user data
  /// 
  /// Returns a column widget with all profile field displays.
  Widget _buildProfileFields(Profile profile) {
    return Column(
      children: [
        ProfileFieldDisplay(
          label: 'First Name',
          value: profile.firstName,
        ),
        const SizedBox(height: 24),
        ProfileFieldDisplay(
          label: 'Last Name',
          value: profile.lastName,
        ),
        const SizedBox(height: 24),
        ProfileFieldDisplay(
          label: 'Email',
          value: profile.email,
        ),
        const SizedBox(height: 24),
        ProfileFieldDisplay(
          label: 'Document',
          value: profile.documentNumber,
        ),
        const SizedBox(height: 24),
        ProfileFieldDisplay(
          label: 'Phone Number',
          value: profile.phone,
        ),
      ],
    );
  }


}
