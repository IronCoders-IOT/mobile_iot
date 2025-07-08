import 'package:flutter/widgets.dart';
import '../../../l10n/app_localizations.dart';

String getLocalizedWaterType(BuildContext context, String type) {
  switch (type.toLowerCase()) {
    case 'water':
      return AppLocalizations.of(context)!.water;
  // Add more types if needed
    default:
      return type;
  }
}