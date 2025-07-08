import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';

/// A reusable widget for displaying welcome messages and section headers.
/// 
/// This widget provides a consistent way to display titles and subtitles
/// throughout the application, particularly on authentication screens and
/// welcome pages. It supports customizable text styling and alignment
/// to fit different design requirements.
/// 
/// The AppWelcomeSection widget is commonly used for:
/// - Login and registration screen headers
/// - Welcome messages on onboarding screens
/// - Section titles in forms and content areas
/// - Brand messaging and app introductions
/// 
/// Features:
/// - Customizable title and subtitle text
/// - Configurable font sizes for both text elements
/// - Flexible text alignment options
/// - Consistent styling with app color scheme
/// - Conditional subtitle display
class AppWelcomeSection extends StatelessWidget {
  /// The main title text to be displayed prominently.
  /// 
  /// This is the primary text that will be shown in bold with the specified
  /// title font size. It should be concise and impactful.
  final String title;

  /// Optional subtitle text displayed below the main title.
  /// 
  /// This text provides additional context or explanation for the title.
  /// If null, only the title will be displayed. The subtitle uses a smaller
  /// font size and different color for visual hierarchy.
  final String? subtitle;

  /// Font size for the main title text.
  /// 
  /// Defaults to 24.0 pixels. This value can be customized to match
  /// different design requirements or screen sizes.
  final double titleFontSize;

  /// Font size for the subtitle text.
  /// 
  /// Defaults to 16.0 pixels. This value can be customized to create
  /// appropriate visual hierarchy with the title.
  final double subtitleFontSize;

  /// Text alignment for both title and subtitle.
  /// 
  /// Defaults to TextAlign.center. This can be changed to left, right,
  /// or center alignment based on the layout requirements.
  final TextAlign textAlign;

  /// Creates a new AppWelcomeSection widget with the specified parameters.
  /// 
  /// [title] - The main title text to display (required)
  /// [subtitle] - Optional subtitle text displayed below the title
  /// [titleFontSize] - Font size for the title (defaults to 24.0)
  /// [subtitleFontSize] - Font size for the subtitle (defaults to 16.0)
  /// [textAlign] - Text alignment for both title and subtitle (defaults to center)
  /// [key] - Widget key for identification and testing
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