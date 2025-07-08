import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';

/// A reusable search bar widget for application screens.
/// 
/// This widget provides a consistent search input field across the application,
/// including search icon, clear functionality, and customizable styling.
/// It follows Material Design principles and uses the app's color scheme.
/// 
/// The search bar supports:
/// - Text input with customizable hint text
/// - Search icon prefix
/// - Clear button when text is entered
/// - Customizable callbacks for text changes and clear actions
/// - Consistent styling with rounded borders and focus states
class AppSearchBar extends StatelessWidget {
  /// The text editing controller for managing the search input.
  final TextEditingController controller;
  
  /// The hint text to display when the search field is empty.
  /// Defaults to 'Search...' if not specified.
  final String hintText;
  
  /// Optional callback for the clear button action.
  /// If not provided, defaults to clearing the controller text.
  final VoidCallback? onClear;
  
  /// Optional callback for text changes in the search field.
  final ValueChanged<String>? onChanged;

  /// Creates an app search bar with the specified parameters.
  /// 
  /// Parameters:
  /// - [key]: Optional widget key
  /// - [controller]: The text editing controller for the search input
  /// - [hintText]: The hint text to display (defaults to 'Search...')
  /// - [onClear]: Optional callback for the clear button
  /// - [onChanged]: Optional callback for text changes
  const AppSearchBar({
    Key? key,
    required this.controller,
    this.hintText = 'Search...',
    this.onClear,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search, color: AppColors.mediumGray),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primaryBlue.withOpacity(0.2),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primaryBlue,
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: onClear ?? () => controller.clear(),
                  child: const Icon(
                    Icons.clear,
                    color: AppColors.mediumGray,
                    size: 20,
                  ),
                )
              : null,
        ),
      ),
    );
  }
} 