import 'package:flutter/material.dart';

String getStatusFromQuality(String quality) {
  switch (quality.toLowerCase()) {
    case 'Excellent':
      return 'normal';
    case 'Good':
      return 'normal';
    case 'Acceptable':
      return 'normal';
    case 'Bad':
      return 'alert';
    case 'Non-potable':
      return 'alert';
    case 'Contaminated water':
      return 'critical';
    default:
      return 'normal';
  }
}

String getEventStatusColor(String status) {
  switch (status) {
    case 'normal':
      return 'Normal';
    case 'alert':
      return 'Alert';
    case 'critical':
      return 'Critical';
    default:
      return 'Unknown';
  }
}

Color getReportStatusColor(String status) {
  switch (status) {
    case 'normal':
      return const Color(0xFFE8F5E9); // Light green
    case 'alert':
      return const Color(0xFFFFE0B2); // Light orange
    case 'critical':
      return const Color(0xFFFFEBEE); // Light red
    default:
      return Colors.grey.shade200;
  }
}

Color getReportStatusTextColor(String status) {
  switch (status) {
    case 'normal':
      return const Color(0xFF4CAF50); // Green
    case 'alert':
      return const Color(0xFFFF9800); // Orange
    case 'critical':
      return const Color(0xFFD32F2F); // Red
    default:
      return Colors.grey;
  }
}
