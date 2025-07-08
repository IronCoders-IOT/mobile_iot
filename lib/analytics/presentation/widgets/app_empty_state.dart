import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';

/// A reusable empty state widget for application screens.
/// 
/// This widget provides a consistent empty state display across the application,
/// showing an optional icon, title, subtitle, and action button when no data
/// is available. It follows Material Design principles and uses the app's color scheme.
/// 
/// The empty state supports:
/// - Optional icon with consistent styling
/// - Title and optional subtitle text
/// - Optional action button with customizable text
/// - Consistent styling and spacing
/// - Reusable across different screens and contexts
class AppEmptyState extends StatelessWidget {
  /// The main title text to display in the empty state.
  final String title;
  
  /// Optional subtitle text to display below the title.
  final String? subtitle;
  
  /// Optional icon to display above the title.
  final IconData? icon;
  
  /// Optional callback for the action button.
  /// If provided along with actionText, an action button will be displayed.
  final VoidCallback? onAction;
  
  /// Optional text for the action button.
  /// Must be provided along with onAction for the button to appear.
  final String? actionText;

  /// Creates an app empty state with the specified parameters.
  /// 
  /// Parameters:
  /// - [key]: Optional widget key
  /// - [title]: The main title text to display
  /// - [subtitle]: Optional subtitle text
  /// - [icon]: Optional icon to display
  /// - [onAction]: Optional callback for the action button
  /// - [actionText]: Optional text for the action button
  const AppEmptyState({
    Key? key,
    required this.title,
    this.subtitle,
    this.icon,
    this.onAction,
    this.actionText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 64,
                color: AppColors.mediumGray.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.mediumGray,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 