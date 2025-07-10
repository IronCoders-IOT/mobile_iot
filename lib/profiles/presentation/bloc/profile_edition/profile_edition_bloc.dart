import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/profiles/application/profile_use_case.dart';
import 'package:mobile_iot/profiles/application/resident_use_case.dart';
import 'package:mobile_iot/profiles/presentation/bloc/profile_edition/profile_edition_event.dart';
import 'package:mobile_iot/profiles/presentation/bloc/profile_edition/profile_edition_state.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/shared/exceptions/session_expired_exception.dart';

/// BLoC for managing profile edition state and business logic.
///
/// This BLoC handles all profile edition-related operations including loading,
/// updating, and resetting profile data. It coordinates between the presentation
/// layer and the business logic layer, managing the complete lifecycle of profile
/// data for editing purposes.
///
/// The BLoC follows the BLoC pattern for state management and provides:
/// - Data fetching and updating for the profile data source
/// - Form validation and state management
/// - Error handling and state management
/// - Authentication and session management
class ProfileEditionBloc extends Bloc<ProfileEditionEvent, ProfileEditionState> {
  final ProfileUseCase _profileUseCase;
  final ResidentUseCase _residentUseCase;
  final SecureStorageService _secureStorage;

  /// Creates a profile edition BLoC with the required dependencies.
  ///
  /// Parameters:
  /// - [profileUseCase]: Use case for profile operations
  /// - [residentUseCase]: Use case for resident operations
  /// - [secureStorage]: Service for secure storage
  ProfileEditionBloc({
    required ProfileUseCase profileUseCase,
    required ResidentUseCase residentUseCase,
    required SecureStorageService secureStorage,
  })  : _profileUseCase = profileUseCase,
        _residentUseCase = residentUseCase,
        _secureStorage = secureStorage,
        super(ProfileEditionInitialState()) {
    // Register event handlers
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<ResetProfileEvent>(_onResetProfile);
  }

  /// Handles the load profile event.
  ///
  /// This method performs the complete data fetching process:
  /// 1. Retrieves authentication token
  /// 2. Fetches profile for the authenticated user
  /// 3. Fetches resident data for the authenticated user
  /// 4. Emits loaded or error state
  ///
  /// Parameters:
  /// - [event]: The load profile event
  /// - [emit]: The state emitter
  ///

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileEditionState> emit,
  ) async {
    emit(ProfileEditionLoadingState());
    try {
      final token = await _secureStorage.getToken();
      if (token == null) throw Exception('No authentication token found');
      
      final profile = await _profileUseCase.getProfile(token);
      final resident = await _residentUseCase.getProfile(token);
      
      if (profile != null) {
        emit(ProfileEditionLoadedState(profile: profile, resident: resident));
      } else {
        emit(ProfileEditionErrorState('Failed to load profile data'));
      }
    } on SessionExpiredException {
      emit(ProfileEditionSessionExpiredState());
    } catch (e) {
      emit(ProfileEditionErrorState('Error loading profile: ˜{e.toString()}'));
    }
  }

  /// Handles the update profile event.
  ///
  /// This method performs the complete profile update process:
  /// 1. Retrieves authentication token
  /// 2. Updates profile for the authenticated user
  /// 3. Fetches updated profile and resident data
  /// 4. Emits updated or error state
  ///
  /// Parameters:
  /// - [event]: The update profile event
  /// - [emit]: The state emitter
  ///

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileEditionState> emit,
  ) async {
    emit(ProfileEditionUpdatingState());
    try {
      final token = await _secureStorage.getToken();
      if (token == null) throw Exception('No authentication token found');
      await _profileUseCase.updateProfile(token, event.profile);
      final updatedProfile = await _profileUseCase.getProfile(token);
      final resident = await _residentUseCase.getProfile(token);
      if (updatedProfile != null) {
        emit(ProfileEditionUpdatedState(profile: updatedProfile, resident: resident));
      } else {
        emit(ProfileEditionErrorState('No se pudo obtener el perfil actualizado'));
      }
    } on SessionExpiredException {
      emit(ProfileEditionSessionExpiredState());
    } catch (e) {
      emit(ProfileEditionErrorState('Error updating profile: ˜{e.toString()}'));
    }
  }

  /// Handles the reset profile event.
  ///
  /// This method resets the profile edition state to its initial state.
  ///
  /// Parameters:
  /// - [event]: The reset profile event
  /// - [emit]: The state emitter
  ///
  void _onResetProfile(
    ResetProfileEvent event,
    Emitter<ProfileEditionState> emit,
  ) {
    emit(ProfileEditionInitialState());
  }
} 