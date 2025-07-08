import 'package:flutter/material.dart';

/// Utility class for managing colors associated with water request statuses.
/// 
/// This class provides static methods to retrieve appropriate colors
/// for displaying water request status indicators in the user interface.
/// It includes both text colors and background colors for status badges.
class WaterRequestStatusColors {
  /// Returns the primary color for water request status text and icons.
  /// 
  /// Provides distinct colors for different status types to help users
  /// quickly identify the current state of their water requests.
  /// 
  /// Parameters:
  /// - [status]: The water request status (e.g., 'IN_PROGRESS', 'RECEIVED', 'CLOSED')
  /// 
  /// Returns a Color object representing the status color:
  /// - 'IN_PROGRESS': Blue (#3498DB)
  /// - 'RECEIVED': Green (#28A745)
  /// - 'CLOSED': Red (#E74C3C)
  /// - default: Gray (#6C757D)
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

  /// Returns the background color for water request status badges.
  /// 
  /// Provides light background colors that complement the primary
  /// status colors for creating visually appealing status indicators.
  /// 
  /// Parameters:
  /// - [status]: The water request status (e.g., 'IN_PROGRESS', 'RECEIVED', 'CLOSED')
  /// 
  /// Returns a Color object representing the background color:
  /// - 'IN_PROGRESS': Light blue (#E3F2FD)
  /// - 'RECEIVED': Light green (#D6FFE6)
  /// - 'CLOSED': Light red (#FFE3E3)
  /// - default: Light gray (#F0F1F2)
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