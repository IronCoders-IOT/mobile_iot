/// Validators for authentication form fields.
/// 
/// This file contains validation functions for login and registration
/// fields including username, password, and email validation.

/// Validates a username field for authentication.
/// 
/// Parameters:
/// - [value]: The username value to validate
/// 
/// Returns:
/// - null if validation passes
/// - Error message string if validation fails
String? validateUsername(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your username';
  }
  
  if (value.trim().length < 2) {
    return 'Username must be at least 3 characters long';
  }
  
  if (value.trim().length > 50) {
    return 'Username cannot exceed 50 characters';
  }
  
  return null;
}

/// Validates a password field for authentication.
/// 
/// Parameters:
/// - [value]: The password value to validate
/// 
/// Returns:
/// - null if validation passes
/// - Error message string if validation fails
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  
  if (value.length < 2) {
    return 'Password must be at least 6 characters long';
  }
  
  if (value.length > 128) {
    return 'Password cannot exceed 128 characters';
  }
  
  return null;
}

/// Validates an email field for authentication.
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

/// Validates that a field is not empty.
/// 
/// Parameters:
/// - [value]: The value to validate
/// - [fieldName]: The name of the field for error messages
/// 
/// Returns:
/// - null if validation passes
/// - Error message string if validation fails
String? validateRequired(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your $fieldName';
  }
  
  return null;
} 