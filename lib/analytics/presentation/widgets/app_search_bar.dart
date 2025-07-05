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