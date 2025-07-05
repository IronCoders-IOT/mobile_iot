import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';
import 'package:mobile_iot/shared/widgets/app_logo.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onAdd;
  final String? addButtonText;

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