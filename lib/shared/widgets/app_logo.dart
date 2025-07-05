import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppLogo extends StatelessWidget {
  final double fontSize;
  final TextAlign textAlign;

  const AppLogo({
    Key? key,
    this.fontSize = 36,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Aqua',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),
          TextSpan(
            text: 'Conecta',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
} 