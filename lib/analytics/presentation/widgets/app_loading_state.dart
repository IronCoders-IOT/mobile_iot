import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';

class AppLoadingState extends StatelessWidget {
  final String? message;

  const AppLoadingState({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
} 