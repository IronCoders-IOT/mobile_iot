import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';

/// A reusable card widget for displaying list items in the application.
/// 
/// This widget provides a consistent card layout for list items across the application,
/// supporting various content types including titles, subtitles, descriptions,
/// and trailing widgets. It follows Material Design principles and uses the app's color scheme.
/// 
/// The card supports:
/// - Optional title, subtitle, and description text
/// - Custom trailing widget (e.g., status badges, icons)
/// - Custom child widget for complex layouts
/// - Tap functionality with customizable callback
/// - Customizable background color
/// - Consistent styling with rounded corners and borders
class AppListCard extends StatelessWidget {
  final String? title;
  
  final String? subtitle;
  
  final String? description;
  
  final Widget? trailing;

  final Widget? child;
  
  final VoidCallback? onTap;
  
  final Color? backgroundColor;

  /// Creates an app list card with the specified parameters.
  /// 
  /// Parameters:
  /// - [key]: Optional widget key
  /// - [title]: Optional main title text
  /// - [subtitle]: Optional subtitle text
  /// - [description]: Optional description text
  /// - [trailing]: Optional trailing widget
  /// - [child]: Optional custom child widget
  /// - [onTap]: Optional tap callback
  /// - [backgroundColor]: Optional background color
  const AppListCard({
    Key? key,
    this.title,
    this.subtitle,
    this.description,
    this.trailing,
    this.child,
    this.onTap,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.mediumGray.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: child ?? Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkBlue,
                      ),
                    ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ],
                  if (description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      description!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 12),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
} 