import 'package:flutter/widgets.dart';
import '../../../l10n/app_localizations.dart';

/// Returns a localized, user-friendly string for a given backend event type code.
///
/// This function maps backend event type identifiers (e.g., 'water-measurement')
/// to their corresponding localized strings using AppLocalizations. If the event type
/// is not recognized, it returns the original code as a fallback.
///
/// Parameters:
/// - [context]: The BuildContext used to access localization
/// - [type]: The backend event type code to localize
///
/// Returns a localized string for the event type, or the original code if not mapped.
String getLocalizedEventType(BuildContext context, String type) {
  switch (type) {
    case 'water-measurement':
      return AppLocalizations.of(context)!.waterMeasurement;
    // Add more event types as needed
    default:
      return type;
  }
} 