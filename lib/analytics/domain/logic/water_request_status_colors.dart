import 'package:flutter/material.dart';

class WaterRequestStatusColors {
  static Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'IN_PROGRESS':
        return const Color(0xFF3498DB); // blue
      case 'RECEIVED':
        return const Color(0xFF28A745); // green
      case 'CLOSED':
        return const Color(0xFFE74C3C); // red
      default:
        return const Color(0xFF6C757D); // gray
    }
  }

  static Color getStatusBackgroundColor(String status) {
    switch (status.toUpperCase()) {
      case 'IN_PROGRESS':
        return const Color(0xFFE3F2FD); // light blue background
      case 'RECEIVED':
        return const Color(0xFFD6FFE6); // light green background
      case 'CLOSED':
        return const Color(0xFFFFE3E3); // light red background
      default:
        return const Color(0xFFF0F1F2); // very light gray
    }
  }
} 