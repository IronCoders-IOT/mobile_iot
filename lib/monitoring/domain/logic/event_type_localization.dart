import 'package:flutter/widgets.dart';
import '../../../l10n/app_localizations.dart';

/// Returns a localized, user-friendly string for a given backend event type code.
///
/// Parameters:
/// - [context]: The BuildContext used to access localization
/// - [type]: The backend event type code to localize
///
String getLocalizedEventType(BuildContext context, String type) {
  final normalizedType = type.trim().toLowerCase().replaceAll(' ', '-').replaceAll('_', '-');
  switch (normalizedType) {
    case 'water-measurement':
      return AppLocalizations.of(context)!.waterMeasurement;
    case 'monitoring-measurement':
      return AppLocalizations.of(context)!.waterMonitoring;
    default:
      return type;
  }
}