/// Returns the pH value based on the water status.
///
/// This function maps water status categories to representative pH values
/// for display purposes in the dashboard and monitoring screens.
/// The pH values are indicative of water quality levels.
///
/// Parameters:
/// - [status]: The water status ('normal', 'alert', 'critical')
///
///
double getPhFromStatus(String status) {
  switch (status) {
    case 'Excellent':
      return 7.2;
    case 'Good':
      return 7.0;
    case 'Acceptable':
      return 6.8;
    case 'Bad':
      return 5.5;
    case 'Non-potable':
      return 4.8;
    case 'Contaminated water':
      return 3.0;
    default:
      return 7.0; // default fallback pH
  }

} 