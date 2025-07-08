/// Utility class for formatting status values for display in the user interface.
/// 
/// This class provides static methods to convert internal status values
/// to user-friendly display text, ensuring consistent formatting
/// across the application.
class StatusFormatter {
  /// Formats water request status values for display.
  /// 
  /// Converts internal status values to human-readable text
  /// for water supply request status indicators.
  /// 
  /// Parameters:
  /// - [status]: The internal status value (e.g., 'received', 'in_progress', 'closed')
  /// 
  /// Returns a formatted status string suitable for UI display.
  static String formatWaterRequestStatus(String status) {
    switch (status.toLowerCase()) {
      case 'received':
        return 'Received';
      case 'in_progress':
        return 'In Progress';
      case 'closed':
        return 'Closed';
      default:
        return status;
    }
  }

  /// Formats report status values for display.
  /// 
  /// Converts internal status values to human-readable text
  /// for report status indicators.
  /// 
  /// Parameters:
  /// - [status]: The internal status value (e.g., 'received', 'in_progress', 'closed')
  /// 
  /// Returns a formatted status string suitable for UI display.
  static String formatReportStatus(String status) {
    switch (status.toLowerCase()) {
      case 'received':
        return 'Received';
      case 'in_progress':
        return 'In Progress';
      case 'closed':
        return 'Closed';
      default:
        return status;
    }
  }
} 