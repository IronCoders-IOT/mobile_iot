import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/widgets/app_colors.dart';
import 'package:mobile_iot/shared/widgets/app_logo.dart';

/// Widget that displays the profile header section with logo, logout, and edit actions.
///
/// This widget is used at the top of the profile screen to provide branding (logo),
/// a logout button, and an edit button. It is customizable via callbacks for logout and edit actions.
class ProfileHeader extends StatelessWidget {
  final VoidCallback? onLogout;
  final VoidCallback? onEdit;

  const ProfileHeader({
    Key? key,
    this.onLogout,
    this.onEdit,
  }) : super(key: key);

  /// Builds the profile header widget.
  ///
  /// Parameters:
  /// - [context]: The build context
  ///
  /// Returns a [Widget] containing the profile header UI.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: const Icon(
                Icons.edit,
                color: AppColors.darkBlue,
                size: 24,
              ),
            ),
          if (onEdit != null) const SizedBox(width: 16),
          Expanded(
            child: Center(
              child: AppLogo(),
            ),
          ),
          if (onLogout != null)
            GestureDetector(
              onTap: onLogout,
              child: const Icon(
                Icons.logout,
                color: AppColors.darkBlue,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }
} 