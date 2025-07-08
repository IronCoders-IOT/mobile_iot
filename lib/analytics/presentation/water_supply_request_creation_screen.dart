import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/analytics/infrastructure/service/water_request_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/repositories/water_request_repository_impl.dart';
import 'package:mobile_iot/analytics/presentation/bloc/water_supply_request_creation/bloc/bloc.dart';
import '../../l10n/app_localizations.dart';

import '../../shared/widgets/app_colors.dart';

/// A dialog screen for creating water supply requests with BLoC state management.
/// 
/// This screen uses the BLoC pattern for state management and provides the following features:
/// - Create water supply requests with liters input
/// - Input validation for water amount
/// - Real-time error handling and display
/// - Loading states during request creation
/// - Automatic dialog closure on successful creation
/// - Success feedback via snackbar
/// 
/// The screen automatically handles:
/// - Input validation and error display
/// - Loading states while creating requests
/// - Error states with user feedback
/// - Success states with automatic navigation
/// - Authentication token validation
/// 
class WaterSupplyRequestCreationScreen extends StatelessWidget {
  const WaterSupplyRequestCreationScreen({super.key});

  /// Shows the water supply request creation dialog.
  /// 
  /// Returns the number of liters requested if successful, null otherwise.
  /// 
  /// Parameters:
  /// - [context]: The build context for showing the dialog
  /// 
  /// Returns a Future<int?> representing the result of the request creation.
  static Future<int?> show(BuildContext context) {
    return showDialog<int>(
      context: context,
      builder: (context) => const WaterSupplyRequestCreationScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WaterSupplyRequestCreationBloc>(
      create: (context) => WaterSupplyRequestCreationBloc(
        repository: WaterRequestRepositoryImpl(WaterRequestApiService()),
        secureStorage: SecureStorageService(),
      ),
      child: BlocConsumer<WaterSupplyRequestCreationBloc, WaterSupplyRequestCreationState>(
        listener: (context, state) {
          if (state is WaterSupplyRequestCreationSuccessState) {
            Navigator.pop(context, state.liters);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.waterRequestSent),
                backgroundColor: AppColors.primaryBlue,
              ),
            );
          } else if (state is WaterSupplyRequestCreationErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.requestWater,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Icon(
                    Icons.water_drop,
                    color: AppColors.primaryBlue,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 24),
                _buildInputField(context),
                const SizedBox(height: 24),
                _buildButtons(context, state),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the liters input field with validation styling.
  /// 
  /// This method creates a text field with:
  /// - Number keyboard type
  /// - Water drop icon prefix
  /// - Custom border styling
  /// - Proper focus states
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// 
  /// Returns a TextField widget for liters input.
  Widget _buildInputField(BuildContext context) {
    final litersController = TextEditingController();
    
    return TextField(
      controller: litersController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.liters,
        hintText: AppLocalizations.of(context)!.enterAmountOfWater,
        prefixIcon: const Icon(Icons.water_drop_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primaryBlue.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }

  /// Builds the action buttons (Cancel and Request).
  /// 
  /// This method creates a row with:
  /// - Cancel button that closes the dialog
  /// - Request button that triggers water request creation
  /// - Loading state handling for the request button
  /// 
  /// Parameters:
  /// - [context]: The build context
  /// - [state]: The current BLoC state
  /// 
  /// Returns a Row widget containing the action buttons.
  Widget _buildButtons(BuildContext context, WaterSupplyRequestCreationState state) {
    final litersController = TextEditingController();
    final isLoading = state is WaterSupplyRequestCreationLoadingState;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: const TextStyle(
              color: AppColors.mediumGray,
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: isLoading ? null : () => _sendRequest(context, litersController),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(AppLocalizations.of(context)!.request),
        ),
      ],
    );
  }

  /// Handles the water request submission.
  /// 
  /// This method:
  /// - Gets the liters value from the controller
  /// - Creates a CreateWaterSupplyRequestEvent
  /// - Dispatches the event to the BLoC for processing
  /// 
  /// Parameters:
  /// - [context]: The build context for accessing the BLoC
  /// - [litersController]: Controller containing the liters input
  void _sendRequest(BuildContext context, TextEditingController litersController) {
    context.read<WaterSupplyRequestCreationBloc>().add(
      CreateWaterSupplyRequestEvent(
        liters: litersController.text,
      ),
    );
  }
}
