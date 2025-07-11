import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// Converts water quality values to standardized status categories.
/// 
/// This function maps various water quality descriptions to three
/// standardized status categories: 'normal', 'alert', and 'critical'.
/// Used for consistent status display across the application.
/// 
/// Parameters:
/// - [context]: The BuildContext used to access localization
/// - [quality]: The water quality string from device data (localized or English)
/// 
/// Returns a standardized status string
String getStatusFromQuality(BuildContext context, String quality) {
  final localizations = AppLocalizations.of(context)!;

  final q = quality.toLowerCase();
  if (q == localizations.excellent.toLowerCase() || q == 'excellent') {
    return 'normal';
  } else if (q == localizations.good.toLowerCase() || q == 'good') {
    return 'normal';
  } else if (q == localizations.acceptable.toLowerCase() || q == 'acceptable') {
    return 'normal';
  } else if (q == localizations.bad.toLowerCase() || q == 'bad') {
    return 'alert';
  } else if (q == localizations.nonPotable.toLowerCase() || q == 'non-potable') {
    return 'alert';
  } else if (q == localizations.contaminated.toLowerCase() || q == 'contaminated' || q == 'contaminated water' || q == 'contaminated monitoring') {
    return 'critical';
  } else {
    return 'normal';
  }
}

/// Converts status values to user-friendly display text.
/// 
/// This function maps internal status values to human-readable
/// text for display in the user interface.
/// 
/// Parameters:
/// - [status]: The internal status value
/// 
/// Returns a user-friendly status text
String getEventStatusColor(BuildContext context, String status) {
  switch (status) {
    case 'normal':
      return AppLocalizations.of(context)!.normal;
    case 'alert':
      return AppLocalizations.of(context)!.alert;
    case 'critical':
      return AppLocalizations.of(context)!.critical;
    default:
      return AppLocalizations.of(context)!.unknown;
  }
}

/// Returns the background color for report status indicators.
/// 
/// This function provides appropriate background colors for status
/// badges and indicators based on the severity level of the status.
/// 
/// Parameters:
/// - [status]: The status value
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
/// - [status]: The status value
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
