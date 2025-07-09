/// Validates a first or last name field.
/// 
/// Parameters:
/// - [value]: The name value to validate
/// - [fieldName]: The name of the field for error messages (e.g., "First Name", "Last Name")
/// 
/// Returns:
/// - null if validation passes
/// - Error message string if validation fails
String? validateName(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your $fieldName';
  }
  
  if (value.trim().length < 2) {
    return '$fieldName must be at least 2 characters long';
  }
  
  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
    return '$fieldName can only contain letters and spaces';
  }
  
  return null;
}

/// Validates a username field.
/// 
/// Parameters:
/// - [value]: The username value to validate
/// 
/// Returns:
/// - null if validation passes
/// - Error message string if validation fails
String? validateUsername(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter a username';
  }
  
  if (value.trim().length < 3) {
    return 'Username must be at least 3 characters long';
  }
  
  if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
    return 'Username can only contain letters, numbers, and underscores';
  }
  
  return null;
}

/// Validates an email address field.
/// 
/// Parameters:
/// - [value]: The email value to validate
/// 
/// Returns:
/// - null if validation passes
/// - Error message string if validation fails
String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your email';
  }
  
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  if (!emailRegex.hasMatch(value.trim())) {
    return 'Please enter a valid email address';
  }
  
  return null;
}

/// Validates a phone number field.
/// 
/// Parameters:
/// - [value]: The phone number value to validate
/// 
/// Returns:
/// - null if validation passes
/// - Error message string if validation fails
String? validatePhone(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your phone number';
  }
  
  // Remove all non-digit characters for validation
  final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
  
  if (digitsOnly.length < 7) {
    return 'Phone number must be at least 7 digits long';
  }
  
  if (digitsOnly.length > 15) {
    return 'Phone number cannot exceed 15 digits';
  }
  
  return null;
}

/// Validates a document number field.
/// 
/// Parameters:
/// - [value]: The document number value to validate
/// 
/// Returns:
/// - null if validation passes
/// - Error message string if validation fails
String? validateDocumentNumber(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your document number';
  }
  
  if (value.trim().length < 5) {
    return 'Document number must be at least 5 characters long';
  }
  
  return null;
}

/// Validates a direction/address field.
/// 
/// Parameters:
/// - [value]: The direction value to validate
/// 
/// Returns:
/// - null if validation passes
/// - Error message string if validation fails
String? validateDirection(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your address';
  }
  
  if (value.trim().length < 10) {
    return 'Address must be at least 10 characters long';
  }
  
  return null;
} 