/// This entity encapsulates historical water data including the time
/// of the reading, the quantity measured, and the type of reading.
/// Used primarily for displaying recent activity in the dashboard
/// and water history sections.
class WaterReading {
  final String time;
  
  final String quantity;
  
  final String type;

  WaterReading({
    required this.time,
    required this.quantity,
    required this.type,
  });
} 