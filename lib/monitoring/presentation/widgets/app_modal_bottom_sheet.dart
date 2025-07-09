import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';

/// A reusable modal bottom sheet widget for application screens.
/// 
/// This widget provides a consistent modal bottom sheet layout across the application,
/// including a title header with close functionality and customizable content.
/// It follows Material Design principles and uses the app's color scheme.
/// 
/// The modal bottom sheet supports:
/// - Title header with close button
/// - Customizable content through children widgets
/// - Consistent styling with rounded top corners
/// - Optional custom close callback
/// - Reusable across different screens and contexts
class AppModalBottomSheet extends StatelessWidget {
  final String title;
  
  final List<Widget> children;

  final VoidCallback? onClose;

  /// Creates an app modal bottom sheet with the specified parameters.
  /// 
  /// Parameters:
  /// - [key]: Optional widget key
  /// - [title]: The title text to display in the header
  /// - [children]: The list of widgets to display as content
  /// - [onClose]: Optional callback for the close button
  const AppModalBottomSheet({
    Key? key,
    required this.title,
    required this.children,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
              GestureDetector(
                onTap: onClose ?? () => Navigator.pop(context),
                child: const Icon(
                  Icons.close,
                  color: AppColors.mediumGray,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
} 