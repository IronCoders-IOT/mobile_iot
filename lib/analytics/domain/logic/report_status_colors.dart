import 'package:flutter/material.dart';

class ReportStatusColors {
  static Color statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'RECEIVED':
        return const Color(0xFFD6ECFF); // light blue background
      case 'IN_PROGRESS':
        return const Color(0xFFFFF6D6); // light yellow background
      case 'CLOSED':
        return const Color(0xFFD6FFE6); // light green background
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }

  static Color statusTextColor(String status) {
    switch (status.toUpperCase()) {
      case 'RECEIVED':
        return const Color(0xFF3498DB); // blue
      case 'IN_PROGRESS':
        return const Color(0xFFF4C542); // yellow
      case 'CLOSED':
        return const Color(0xFF28A745); // green
      default:
        return Colors.grey;
    }
  }
} 