import 'package:intl/intl.dart';

/// Utility class for formatting date strings for display in the user interface.
/// 
/// This class provides static methods to convert ISO date strings
/// to user-friendly formatted dates using the intl package.
/// It includes error handling to gracefully handle invalid date inputs.
class DateFormatter {
  /// Formats an ISO date string to a readable date format.
  /// 
  /// Converts ISO 8601 date strings to a user-friendly format
  /// that includes the full month name, day, year, and time.
  /// 
  /// Parameters:
  /// - [isoString]: The ISO 8601 date string to format
  /// 
  /// Returns a formatted date string (e.g., "December 25, 2023, 2:30 PM")
  /// or the original string if parsing fails.
  static String formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('MMMM d, yyyy, h:mm a').format(date);
    } catch (e) {
      return isoString; // Return original string if parsing fails
    }
  }

  /// Formats an emission date string to a readable date format.
  /// 
  /// Converts ISO 8601 date strings to a user-friendly format
  /// specifically for emission dates in reports and requests.
  /// 
  /// Parameters:
  /// - [isoString]: The ISO 8601 date string to format
  /// 
  /// Returns a formatted date string (e.g., "December 25, 2023, 2:30 PM")
  /// or the original string if parsing fails.
  static String formatEmissionDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('MMMM d, yyyy, h:mm a').format(date);
    } catch (e) {
      return isoString; // Return original string if parsing fails
    }
  }
} 