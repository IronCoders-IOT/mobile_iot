import 'package:flutter/material.dart';

/// Converts water quality values to standardized status categories.
/// 
/// This function maps various water quality descriptions to three
/// standardized status categories: 'normal', 'alert', and 'critical'.
/// Used for consistent status display across the application.
/// 
/// Parameters:
/// - [quality]: The water quality string from sensor data
/// 
/// Returns a standardized status string ('normal', 'alert', or 'critical').
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

/// Converts status values to user-friendly display text.
/// 
/// This function maps internal status values to human-readable
/// text for display in the user interface.
/// 
/// Parameters:
/// - [status]: The internal status value ('normal', 'alert', 'critical')
/// 
/// Returns a user-friendly status text ('Normal', 'Alert', 'Critical').
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

/// Returns the background color for report status indicators.
/// 
/// This function provides appropriate background colors for status
/// badges and indicators based on the severity level of the status.
/// 
/// Parameters:
/// - [status]: The status value ('normal', 'alert', 'critical')
/// 
/// Returns a Color object representing the background color for the status.
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

/// Returns the text color for report status indicators.
/// 
/// This function provides appropriate text colors for status
/// badges and indicators that contrast well with the background colors.
/// 
/// Parameters:
/// - [status]: The status value ('normal', 'alert', 'critical')
/// 
/// Returns a Color object representing the text color for the status.
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
