/// Utility class for validating water request input data.
/// 
/// This class provides static methods to validate water request
/// parameters, ensuring data integrity and user input validation
/// before processing water supply requests.
class WaterRequestValidator {
  /// Checks if the provided liters text represents a valid positive number.
  /// 
  /// This method performs a basic validation to determine if the input
  /// can be parsed as a positive integer.
  /// 
  /// Parameters:
  /// - [litersText]: The text input to validate
  /// 
  /// Returns true if the input is a valid positive number, false otherwise.
  static bool isValidLiters(String litersText) {
    final liters = int.tryParse(litersText);
    return liters != null && liters > 0;
  }

  /// Validates water request liters input and returns appropriate error messages.
  /// 
  /// This method performs comprehensive validation of water request input,
  /// checking for empty values, invalid numbers, and reasonable limits.
  /// 
  /// Parameters:
  /// - [litersText]: The text input to validate
  /// 
  /// Returns null if validation passes, or an error message string if validation fails.
  /// Error messages include:
  /// - 'Please enter an amount of water' for empty input
  /// - 'Please enter a valid number' for non-numeric input
  /// - 'Amount must be greater than 0' for zero or negative values
  /// - 'Amount cannot exceed 10,000 liters' for values above the maximum limit
  static String? validateLiters(String litersText) {
    if (litersText.isEmpty) {
      return 'Please enter an amount of water';
    }
    
    final liters = int.tryParse(litersText);
    if (liters == null) {
      return 'Please enter a valid number';
    }
    
    if (liters <= 0) {
      return 'Amount must be greater than 0';
    }
    
    if (liters > 10000) {
      return 'Amount cannot exceed 10,000 liters';
    }
    
    return null;
  }
} 