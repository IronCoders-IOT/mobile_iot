import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';

/// Widget for displaying a single profile field in a read-only format.
///
/// This widget displays a label and the corresponding value for a profile attribute.
class ProfileFieldDisplay extends StatelessWidget {
  /// The label to display above the value.
  final String label;
  /// The value to display.
  final String value;

  /// Creates a [ProfileFieldDisplay] widget.
  ///
  /// Parameters:
  /// - [label]: The label to display
  /// - [value]: The value to display
  const ProfileFieldDisplay({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  /// Builds the profile field display widget.
  ///
  /// Parameters:
  /// - [context]: The build context
  ///
  /// Returns a [Widget] containing the label and value in a styled container.
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.mediumGray.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.darkBlue,
            ),
          ),
        ),
      ],
    );
  }
} 