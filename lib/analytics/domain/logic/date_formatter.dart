import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('MMMM d, yyyy, h:mm a').format(date);
    } catch (e) {
      return isoString; // Return original string if parsing fails
    }
  }

  static String formatEmissionDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('MMMM d, yyyy, h:mm a').format(date);
    } catch (e) {
      return isoString; // Return original string if parsing fails
    }
  }
} 