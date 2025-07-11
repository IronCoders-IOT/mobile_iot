/// A reusable header widget with a back button and title.
///
/// This file defines the [BackHeader] widget, which provides a consistent
/// header with a back navigation button and screen title for app screens.
import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';

/// A header widget with a back button and title for navigation.
///
/// Used at the top of screens to provide back navigation and display the title.
class BackHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const BackHeader({
    Key? key,
    required this.title,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack ?? () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.darkBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),
        ],
      ),
    );
  }
} 