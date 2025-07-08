/// Returns the pH value based on the water status.
///
/// This function maps water status categories to representative pH values
/// for display purposes in the dashboard and monitoring screens.
/// The pH values are indicative of water quality levels.
///
/// Parameters:
/// - [status]: The water status ('normal', 'alert', 'critical')
///
/// Returns a double representing the pH value:
/// - 'normal': 7.0 (neutral)
/// - 'alert': 5.5 (slightly acidic)
/// - 'critical': 3.0 (highly acidic)
/// - default: 7.0 (neutral)
///
double getPhFromStatus(String status) {
  switch (status) {
    case 'normal':
      return 7.0;
    case 'alert':
      return 5.5;
    case 'critical':
      return 3.0;
    default:
      return 7.0;
  }
} 