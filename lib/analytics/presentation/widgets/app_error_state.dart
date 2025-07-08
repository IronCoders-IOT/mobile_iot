import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';

/// A reusable error state widget for application screens.
/// 
/// This widget provides a consistent error display across the application,
/// showing an error icon, message, and optional retry functionality.
/// It follows Material Design principles and uses the app's color scheme.
/// 
/// The error state supports:
/// - Error icon with consistent styling
/// - Error title and detailed message
/// - Optional retry button with customizable text
/// - Consistent styling and spacing
/// - Reusable across different screens and contexts
class AppErrorState extends StatelessWidget {
  /// The error message to display to the user.
  final String message;
  
  /// Optional callback for the retry button.
  /// If provided, a retry button will be displayed.
  final VoidCallback? onRetry;
  
  /// Optional text for the retry button.
  /// Defaults to 'Retry' if not specified.
  final String? retryText;

  /// Creates an app error state with the specified parameters.
  /// 
  /// Parameters:
  /// - [key]: Optional widget key
  /// - [message]: The error message to display
  /// - [onRetry]: Optional callback for the retry button
  /// - [retryText]: Optional text for the retry button
  const AppErrorState({
    Key? key,
    required this.message,
    this.onRetry,
    this.retryText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(retryText ?? 'Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 