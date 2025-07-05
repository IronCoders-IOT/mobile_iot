class WaterRequestValidator {
  static bool isValidLiters(String litersText) {
    final liters = int.tryParse(litersText);
    return liters != null && liters > 0;
  }

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