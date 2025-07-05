import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';

class AppWelcomeSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double titleFontSize;
  final double subtitleFontSize;
  final TextAlign textAlign;

  const AppWelcomeSection({
    Key? key,
    required this.title,
    this.subtitle,
    this.titleFontSize = 24,
    this.subtitleFontSize = 16,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.darkBlue,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            textAlign: textAlign,
            style: TextStyle(
              fontSize: subtitleFontSize,
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ],
    );
  }
} 