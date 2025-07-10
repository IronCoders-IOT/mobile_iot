import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';
import 'package:mobile_iot/shared/widgets/app_logo.dart';

/// A reusable header widget for application screens.
/// 
/// This widget provides a consistent header layout across the application,
/// including optional back navigation, title display, and action buttons.
/// It follows Material Design principles and uses the app's color scheme.
/// 
/// The header supports:
/// - Back navigation with customizable callback
/// - Centered title display
/// - Optional action button (e.g., "Add" button)
/// - Consistent styling and spacing
class AppHeader extends StatelessWidget {
  final String title;
  
  final VoidCallback? onBack;
  
  final VoidCallback? onAdd;
  
  final String? addButtonText;

  /// Creates an app header with the specified parameters.
  /// 
  /// Parameters:
  /// - [key]: Optional widget key
  /// - [title]: The title to display in the header
  /// - [onBack]: Optional callback for back navigation
  /// - [onAdd]: Optional callback for the action button
  /// - [addButtonText]: Optional text for the action button
  const AppHeader({
    Key? key,
    required this.title,
    this.onBack,
    this.onAdd,
    this.addButtonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          if (onBack != null)
            GestureDetector(
              onTap: onBack,
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.darkBlue,
                size: 24,
              ),
            ),
          if (onBack != null) const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
            ),
          ),
          if (onAdd != null)
            GestureDetector(
              onTap: onAdd,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  addButtonText ?? 'Add',
                  style: const TextStyle(
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
} 