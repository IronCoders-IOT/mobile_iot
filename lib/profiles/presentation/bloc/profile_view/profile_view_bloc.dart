import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/profiles/application/profile_use_case.dart';
import 'package:mobile_iot/profiles/presentation/bloc/profile_view/profile_view_event.dart';
import 'package:mobile_iot/profiles/presentation/bloc/profile_view/profile_view_state.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';

/// BLoC for managing profile viewing state and business logic.
///
/// This BLoC handles all profile view-related operations including fetching
/// and refreshing profile data. It coordinates between the presentation layer
/// and the business logic layer, managing the complete lifecycle of profile
/// data for display purposes.
///
/// The BLoC follows the BLoC pattern for state management and provides:
/// - Data fetching from the profile data source
/// - Refresh functionality
/// - Error handling and state management
/// - Authentication and session management
class ProfileViewBloc extends Bloc<ProfileViewEvent, ProfileViewState> {
  final ProfileUseCase _profileUseCase;
  final SecureStorageService _secureStorage;

  ProfileViewBloc({
    required ProfileUseCase profileUseCase,
    required SecureStorageService secureStorage,
  })  : _profileUseCase = profileUseCase,
        _secureStorage = secureStorage,
        super(ProfileViewInitialState()) {
    // Register event handlers
    on<LoadProfileViewEvent>(_onLoadProfile);
    on<RefreshProfileViewEvent>(_onRefreshProfile);
  }

  /// Handles the load profile event.
  ///
  /// This method performs the complete data fetching process:
  /// 1. Retrieves authentication token
  /// 2. Fetches profile for the authenticated user
  /// 3. Emits loaded or error state
  ///
  /// Parameters:
  /// - [event]: The load profile event
  /// - [emit]: The state emitter
  ///
  /// Emits:
  /// - [ProfileViewLoadingState]
  /// - [ProfileViewLoadedState]
  /// - [ProfileViewErrorState]
  Future<void> _onLoadProfile(
    LoadProfileViewEvent event,
    Emitter<ProfileViewState> emit,
  ) async {
    emit(ProfileViewLoadingState());
    try {
      final token = await _secureStorage.getToken();
      if (token == null) throw Exception('No authentication token found');
      final profile = await _profileUseCase.getProfile(token);
      if (profile != null) {
        emit(ProfileViewLoadedState(profile: profile));
      } else {
        emit(ProfileViewErrorState('Failed to load profile data'));
      }
    } catch (e) {
      emit(ProfileViewErrorState('Error loading profile: ${e.toString()}'));
    }
  }

  /// Handles the refresh profile event.
  ///
  /// This method triggers a complete refresh of the profile data
  /// by re-fetching from the data source, typically used for
  /// pull-to-refresh functionality.
  ///
  /// Parameters:
  /// - [event]: The refresh profile event
  /// - [emit]: The state emitter
  ///
  /// Emits:
  /// - [ProfileViewLoadedState]
  /// - [ProfileViewErrorState]
  Future<void> _onRefreshProfile(
    RefreshProfileViewEvent event,
    Emitter<ProfileViewState> emit,
  ) async {
    await _onLoadProfile(LoadProfileViewEvent(), emit);
  }
} 