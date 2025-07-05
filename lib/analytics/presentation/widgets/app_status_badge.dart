import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';

class AppStatusBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double? fontSize;

  const AppStatusBadge({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
} 