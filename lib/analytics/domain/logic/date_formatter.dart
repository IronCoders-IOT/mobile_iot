import 'package:flutter/widgets.dart';
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
  /// - [context]: The BuildContext of the calling widget
  /// - [isoString]: The ISO 8601 date string to format
  /// 
  /// Returns a formatted date string
  /// or the original string if parsing fails.
  static String formatDate(BuildContext context, String isoString) {
    try {
      final date = DateTime.parse(isoString);
      final locale = Localizations.localeOf(context).toString();
      return DateFormat.yMMMMd(locale).add_jm().format(date);
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
  /// - [context]: The BuildContext of the calling widget
  /// - [isoString]: The ISO 8601 date string to format
  /// 
  /// Returns a formatted date string
  /// or the original string if parsing fails.
  static String formatEmissionDate(BuildContext context, String isoString) {
    try {
      final date = DateTime.parse(isoString);
      final locale = Localizations.localeOf(context).toString();
      return DateFormat.yMMMMd(locale).add_jm().format(date);
    } catch (e) {
      return isoString; // Return original string if parsing fails
    }
  }
} 