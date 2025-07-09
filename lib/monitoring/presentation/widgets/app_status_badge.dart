import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';

/// A reusable status badge widget for application screens.
/// 
/// This widget provides a consistent status indicator across the application,
/// displaying text with customizable background and text colors in a pill-shaped badge.
/// It follows Material Design principles and uses the app's color scheme.
/// 
/// The status badge supports:
/// - Customizable text content
/// - Customizable background and text colors
/// - Optional custom font size
/// - Consistent styling with rounded corners
/// - Reusable across different screens and contexts
class AppStatusBadge extends StatelessWidget {
  final String text;
  
  final Color backgroundColor;
  
  final Color textColor;
  
  final double? fontSize;

  /// Creates an app status badge with the specified parameters.
  /// 
  /// Parameters:
  /// - [key]: Optional widget key
  /// - [text]: The text to display in the badge
  /// - [backgroundColor]: The background color of the badge
  /// - [textColor]: The text color of the badge
  /// - [fontSize]: Optional font size for the text
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