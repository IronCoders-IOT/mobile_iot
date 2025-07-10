/// Utility functions for formatting percentage values in the analytics module.
/// 
/// This file contains helper functions for formatting percentage values
/// with specific display rules for different parts of the application.
/// 
/// The functions ensure consistent formatting across the analytics module
/// and provide appropriate display formats for different contexts.

/// Formats the percentage for dashboard display.
/// 
/// This function formats the water level percentage for display in the dashboard.
/// When the percentage is 100%, it shows "100%" without decimals.
/// For other values, it shows 2 decimal places.
/// 
/// Parameters:
/// - [percentage]: The percentage value to format
/// 
/// Returns a formatted string representation of the percentage
/// 
/// Examples:
/// - 100.0 → "100%"
/// - 85.67 → "85.67%"
/// - 99.99 → "99.99%"
String formatDashboardPercentage(double percentage) {
  if (percentage >= 100.0) {
    return '100%';
  }
  return '${percentage.toStringAsFixed(2)}%';
} 