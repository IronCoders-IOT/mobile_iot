/// A reusable bottom navigation bar for main app navigation.
///
/// This file defines the [AppBottomNavigationBar] widget, which provides a
/// consistent navigation bar for switching between main sections of the app.
import 'package:flutter/material.dart';

/// A customizable bottom navigation bar for the app's main sections.
///
/// Supports navigation between reports, dashboard, and profile screens.
class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF3498DB),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, Icons.description, 0, currentIndex == 0),
            _buildNavItem(context, Icons.home, 1, currentIndex == 1),
            _buildNavItem(context, Icons.person, 2, currentIndex == 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, int index, bool isActive) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
          size: 28,
        ),
      ),
    );
  }
} 