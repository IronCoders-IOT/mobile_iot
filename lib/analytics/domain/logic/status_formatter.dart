import 'package:flutter/widgets.dart';
import '../../../l10n/app_localizations.dart';

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
  /// - [context]: The BuildContext of the calling widget
  /// - [status]: The internal status value
  /// 
  /// Returns a formatted status string suitable for UI display.
  static String formatWaterRequestStatus(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'received':
        return AppLocalizations.of(context)!.received;
      case 'in_progress':
        return AppLocalizations.of(context)!.inProgress;
      case 'closed':
        return AppLocalizations.of(context)!.closed;
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
  /// - [context]: The BuildContext of the calling widget
  /// - [status]: The internal status value
  /// 
  /// Returns a formatted status string suitable for UI display.
  static String formatReportStatus(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'received':
        return AppLocalizations.of(context)!.received;
      case 'in_progress':
        return AppLocalizations.of(context)!.inProgress;
      case 'closed':
        return AppLocalizations.of(context)!.closed;
      default:
        return status;
    }
  }
} 