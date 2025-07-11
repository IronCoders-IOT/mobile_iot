import 'package:flutter/widgets.dart';
import '../../../l10n/app_localizations.dart';

/// Returns a severity value for a given water status string, localized for any language.
/// Higher value means worse status.
int statusSeverity(String status, AppLocalizations loc) {
  final s = status.trim().toLowerCase();
  if (s == loc.withoutWater.toLowerCase() || s == 'without water') return 5;
  if (s == loc.contaminated.toLowerCase() || s == 'contaminated' || s == 'contaminated water') return 4;
  if (s == loc.nonPotable.toLowerCase() || s == 'non-potable') return 3;
  if (s == loc.bad.toLowerCase() || s == 'bad') return 2;
  if (s == loc.acceptable.toLowerCase() || s == 'acceptable') return 1;
  if (s == loc.good.toLowerCase() || s == 'good') return 0;
  if (s == loc.excellent.toLowerCase() || s == 'excellent') return 0;
  return 0;
}


/// Returns the worst status from a list of status strings, using localization.
String getWorstStatus(List<String> statuses, AppLocalizations loc) {
  if (statuses.isEmpty) return '';
  return statuses.reduce((a, b) =>
    statusSeverity(a, loc) >= statusSeverity(b, loc) ? a : b);
}

/// Returns the average of a list of doubles, or 0.0 if the list is empty.
double average(List<double> values) {
  if (values.isEmpty) return 0.0;
  return values.reduce((a, b) => a + b) / values.length;
} 