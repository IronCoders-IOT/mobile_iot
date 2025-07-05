import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';

class AppModalBottomSheet extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback? onClose;

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