import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onClear;
  final ValueChanged<String>? onChanged;

  const AppSearchBar({
    Key? key,
    required this.controller,
    this.hintText = 'Search...',
    this.onClear,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.mediumGray.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: AppColors.mediumGray,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: AppColors.mediumGray,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: onClear ?? () => controller.clear(),
              child: const Icon(
                Icons.clear,
                color: AppColors.mediumGray,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
} 