/// Utility functions for formatting percentage values in the monitoring module.
/// 
/// This file contains helper functions for formatting percentage values
/// with specific display rules for different parts of the monitoring module.
/// 
/// The functions ensure consistent formatting across the monitoring module
/// and provide appropriate display formats for different contexts.

/// Formats the percentage for tank events display.
/// 
/// This function formats the water level percentage for display in tank events.
/// Always shows 2 decimal places for consistency.
/// 
/// Parameters:
/// - [levelValue]: The level value string to format
/// 
/// Returns a formatted string representation of the percentage
/// 
/// Examples:
/// - "100" → "100.00%"
/// - "85.67" → "85.67%"
/// - "99.99" → "99.99%"
/// - Invalid input → "original_value%"
String formatTankEventsPercentage(String levelValue) {
  try {
    final percentage = double.parse(levelValue);
    return '${percentage.toStringAsFixed(2)}%';
  } catch (e) {
    // If parsing fails, return the original value
    return '$levelValue%';
  }
} 