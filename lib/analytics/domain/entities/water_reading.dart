/// Represents a water reading history entry for display in the dashboard.
/// 
/// This entity encapsulates historical water data including the time
/// of the reading, the quantity measured, and the type of reading.
/// Used primarily for displaying recent activity in the dashboard
/// and water history sections.
class WaterReading {
  /// The timestamp or time description of when the reading was taken.
  final String time;
  
  /// The water quantity value (e.g., '500L', '75%').
  final String quantity;
  
  /// The type of water reading (e.g., 'Water', 'Quality').
  final String type;

  /// Creates a water reading with the specified parameters.
  /// 
  /// All parameters are required and represent the core data
  /// for displaying water reading history.
  WaterReading({
    required this.time,
    required this.quantity,
    required this.type,
  });
} 