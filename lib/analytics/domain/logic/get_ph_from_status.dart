import 'package:flutter/widgets.dart';
import '../../../l10n/app_localizations.dart';

/// Returns the pH value based on the water status.
///
/// This function maps water status categories to representative pH values
/// for display purposes in the dashboard and monitoring screens.
/// The pH values are indicative of water quality levels.
///
/// Parameters:
/// - [context]: The BuildContext used to access localization
/// - [status]: The water status (localized or English values)
///
double getPhFromStatus(BuildContext context, String status) {
  final localizations = AppLocalizations.of(context)!;

  if (status == localizations.excellent || status == 'Excellent') {
    return 7.2;
  } else if (status == localizations.good || status == 'Good') {
    return 7.0;
  } else if (status == localizations.acceptable || status == 'Acceptable') {
    return 6.8;
  } else if (status == localizations.bad || status == 'Bad') {
    return 5.5;
  } else if (status == localizations.nonPotable || status == 'Non-potable') {
    return 4.8;
  } else if (status == localizations.contaminated || status == 'Contaminated' || status == 'Contaminated water') {
    return 3.0;
  } else if(status== localizations.withoutWater || status == 'Without water') {
    return 0.0;
  }
  return 0.0;
}

/// Returns the localized string for a water status value.
///
/// This function maps backend status values to their localized equivalents.
///
/// Parameters:
/// - [context]: The BuildContext used to access localization
/// - [status]: The water status (English or localized)
///
String getLocalizedWaterStatus(BuildContext context, String status) {
  final loc = AppLocalizations.of(context)!;
  switch (status.trim().toLowerCase()) {
    case 'excellent':
      return loc.excellent;
    case 'good':
      return loc.good;
    case 'acceptable':
      return loc.acceptable;
    case 'bad':
      return loc.bad;
    case 'non-potable':
      return loc.nonPotable;
    case 'contaminated water':
    case 'contaminated monitoring':
    case 'contaminated':
      return loc.contaminated;
    case 'without water':
      return loc.withoutWater;
    default:
      return status;
  }
} 