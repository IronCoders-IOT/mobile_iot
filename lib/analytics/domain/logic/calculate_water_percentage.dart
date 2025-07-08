/// Calculates the average water percentage from a list of events.
///
/// Takes the levelValue from each event, extracts the numeric value,
/// and returns the average as a percentage.
///
/// Returns 0.0 if no events are provided or if parsing fails.
///
double calculateWaterPercentage(List<dynamic> events) {
  if (events.isEmpty) return 0.0;
  
  final values = events
      .map((e) => double.tryParse(e.levelValue.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0)
      .toList();
      
  if (values.isEmpty) return 0.0;
  
  return values.reduce((a, b) => a + b) / values.length;
} 