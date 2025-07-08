import 'package:flutter/material.dart';

/// Utility class for managing colors associated with report statuses.
/// 
/// This class provides static methods to retrieve appropriate colors
/// for displaying report status indicators in the user interface.
/// It includes both background colors and text colors for status badges.
class ReportStatusColors {
  /// Returns the background color for report status badges.
  /// 
  /// Provides light background colors that create visual distinction
  /// between different report statuses while maintaining readability.
  /// 
  /// Parameters:
  /// - [status]: The report status (e.g., 'RECEIVED', 'IN_PROGRESS', 'CLOSED')
  /// 
  /// Returns a Color object representing the background color:
  /// - 'RECEIVED': Light blue (#D6ECFF)
  /// - 'IN_PROGRESS': Light yellow (#FFF6D6)
  /// - 'CLOSED': Light green (#D6FFE6)
  /// - default: Light gray with opacity
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

  /// Returns the text color for report status badges.
  /// 
  /// Provides contrasting text colors that ensure readability
  /// against the background colors while maintaining visual hierarchy.
  /// 
  /// Parameters:
  /// - [status]: The report status (e.g., 'RECEIVED', 'IN_PROGRESS', 'CLOSED')
  /// 
  /// Returns a Color object representing the text color:
  /// - 'RECEIVED': Blue (#3498DB)
  /// - 'IN_PROGRESS': Yellow (#F4C542)
  /// - 'CLOSED': Green (#28A745)
  /// - default: Gray
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