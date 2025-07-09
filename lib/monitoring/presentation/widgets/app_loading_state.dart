import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';

/// A reusable loading state widget for application screens.
/// 
/// This widget provides a consistent loading indicator across the application,
/// displaying a circular progress indicator with an optional message.
/// It follows Material Design principles and uses the app's color scheme.
/// 
/// The loading state supports:
/// - Centered circular progress indicator with app colors
/// - Optional loading message below the indicator
/// - Consistent styling and spacing
/// - Reusable across different screens and contexts
class AppLoadingState extends StatelessWidget {
  final String? message;

  /// Creates an app loading state with the specified parameters.
  /// 
  /// Parameters:
  /// - [key]: Optional widget key
  /// - [message]: Optional loading message to display
  const AppLoadingState({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
} 