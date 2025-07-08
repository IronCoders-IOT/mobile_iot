import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';

/// Widget for editing a single profile field in a form.
///
/// This widget displays a label and a [TextFormField] for editing a profile attribute.
/// It supports custom keyboard types and validation logic.
class ProfileEditField extends StatelessWidget {
  /// The label to display above the input field.
  final String label;
  /// The controller for the input field.
  final TextEditingController controller;
  /// The keyboard type for the input field.
  final TextInputType keyboardType;
  /// The validator function for the input field.
  final String? Function(String?)? validator;

  /// Creates a [ProfileEditField] widget.
  ///
  /// Parameters:
  /// - [label]: The label to display
  /// - [controller]: The controller for the input field
  /// - [keyboardType]: The keyboard type for the input field (default: text)
  /// - [validator]: The validator function for the input field
  const ProfileEditField({
    Key? key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
  }) : super(key: key);

  /// Builds the profile edit field widget.
  ///
  /// Parameters:
  /// - [context]: The build context
  ///
  /// Returns a [Widget] containing the label and input field.
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
} 