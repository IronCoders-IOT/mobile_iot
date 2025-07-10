import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';
import 'package:mobile_iot/shared/widgets/app_logo.dart';
import '../../../l10n/app_localizations.dart';

class AppLoadingState extends StatelessWidget {
  const AppLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightGray,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLogo(fontSize: 48),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.loadingMessage,
              style: const TextStyle(fontSize: 16, color: AppColors.primaryBlue),
            ),
          ],
        ),
      ),
    );
  }
} 