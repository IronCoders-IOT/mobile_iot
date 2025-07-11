import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';

/// Widget for displaying a circular profile avatar with an optional camera icon overlay.
///
/// This widget displays a user's avatar as a circle. If [showCameraIcon] is true and [onCameraTap]
/// is provided, a camera icon is shown in the corner for photo upload or change actions.
class ProfileAvatar extends StatelessWidget {
  final double size;
  final VoidCallback? onCameraTap;
  final bool showCameraIcon;


  const ProfileAvatar({
    Key? key,
    this.size = 100,
    this.onCameraTap,
    this.showCameraIcon = false,
  }) : super(key: key);

  /// Builds the profile avatar widget.
  ///
  /// Parameters:
  /// - [context]: The build context
  ///
  /// Returns a [Widget] containing the avatar and optional camera icon overlay.
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.mediumGray.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            size: size * 0.5,
            color: AppColors.mediumGray.withOpacity(0.7),
          ),
        ),
        if (showCameraIcon && onCameraTap != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onCameraTap,
              child: Container(
                width: size * 0.32,
                height: size * 0.32,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.white,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: AppColors.white,
                  size: size * 0.16,
                ),
              ),
            ),
          ),
      ],
    );
  }
} 