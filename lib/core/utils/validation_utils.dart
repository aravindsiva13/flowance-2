// lib/core/utils/validation_utils.dart

class ValidationUtils {
  ValidationUtils._(); // Private constructor to prevent instantiation

  // Email validation regex pattern
  static final RegExp _emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$');

  // Strong password regex - at least 8 chars, 1 uppercase, 1 lowercase, 1 number
  static final RegExp _strongPasswordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$');
  
  // Phone number regex - supports various formats
  static final RegExp _phoneRegex = RegExp(r'^[\+]?[1-9][\d]{0,15}$');
  
  // URL regex pattern
  static final RegExp _urlRegex = RegExp(r'^(https?|ftp)://[^\s/$.?#].[^\s]*$');

  // ========== REQUIRED FIELD VALIDATION ==========
  
  /// Generic required field validator
  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Required field validator with custom message
  static String? validateRequiredWithMessage(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  // ========== EMAIL VALIDATION ==========
  
  /// Validates if the email format is correct
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return _emailRegex.hasMatch(email.trim());
  }
  
  /// Email validator for form fields
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    final email = value.trim();
    
    if (!isValidEmail(email)) {
      return 'Please enter a valid email address';
    }
    
    if (email.length > 254) {
      return 'Email address is too long';
    }
    
    return null;
  }

  // ========== PASSWORD VALIDATION ==========
  
  /// Validates basic password (minimum 6 characters)
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }
  
  /// Validates strong password (8+ chars, uppercase, lowercase, number)
  static bool isStrongPassword(String password) {
    return _strongPasswordRegex.hasMatch(password);
  }
  
  /// Basic password validator for form fields
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    
    if (value.length > 128) {
      return 'Password is too long (max 128 characters)';
    }
    
    return null;
  }
  
  /// Strong password validator for form fields
  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    if (value.length > 128) {
      return 'Password is too long (max 128 characters)';
    }
    
    return null;
  }
  
  /// Confirm password validator
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  // ========== NAME VALIDATION ==========
  
  /// Validates if the name is acceptable
  static bool isValidName(String name) {
    final trimmedName = name.trim();
    return trimmedName.length >= 2 && trimmedName.length <= 50;
  }
  
  /// Name validator for form fields
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    
    final name = value.trim();
    
    if (name.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    
    if (name.length > 50) {
      return 'Name is too long (max 50 characters)';
    }
    
    // Check for invalid characters (only letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s\-'\.]+$").hasMatch(name)) {
      return 'Name contains invalid characters';
    }
    
    return null;
  }
  
  /// First name validator
  static String? validateFirstName(String? value) {
    return validateName(value);
  }
  
  /// Last name validator
  static String? validateLastName(String? value) {
    return validateName(value);
  }

  // ========== PHONE NUMBER VALIDATION ==========
  
  /// Validates phone number format
  static bool isValidPhoneNumber(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    return _phoneRegex.hasMatch(cleanPhone);
  }
  
  /// Phone number validator for form fields
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    
    final phone = value.trim();
    
    if (!isValidPhoneNumber(phone)) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }
  
  /// Optional phone number validator
  static String? validateOptionalPhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }
    
    return validatePhoneNumber(value);
  }

  // ========== URL VALIDATION ==========
  
  /// Validates URL format
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;
    return _urlRegex.hasMatch(url);
  }
  
  /// URL validator for form fields
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL is required';
    }
    
    if (!isValidUrl(value.trim())) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }
  
  /// Optional URL validator
  static String? validateOptionalUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }
    
    return validateUrl(value);
  }

  // ========== NUMBER VALIDATION ==========
  
  /// Validates if string is a valid number
  static bool isValidNumber(String value) {
    return double.tryParse(value) != null;
  }
  
  /// Number validator for form fields
  static String? validateNumber(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    if (!isValidNumber(value.trim())) {
      return 'Please enter a valid number';
    }
    
    return null;
  }
  
  /// Integer validator for form fields
  static String? validateInteger(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    if (int.tryParse(value.trim()) == null) {
      return 'Please enter a valid whole number';
    }
    
    return null;
  }
  
  /// Positive number validator
  static String? validatePositiveNumber(String? value, [String? fieldName]) {
    final numberValidation = validateNumber(value, fieldName);
    if (numberValidation != null) return numberValidation;
    
    final number = double.parse(value!.trim());
    if (number <= 0) {
      return '${fieldName ?? 'Value'} must be greater than 0';
    }
    
    return null;
  }

  // ========== RANGE VALIDATION ==========
  
  /// Validates string length is within range
  static String? validateLength(
    String? value,
    int minLength,
    int maxLength, [
    String? fieldName,
  ]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    if (value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }
    
    if (value.length > maxLength) {
      return '${fieldName ?? 'This field'} must not exceed $maxLength characters';
    }
    
    return null;
  }
  
  /// Validates number is within range
  static String? validateNumberRange(
    String? value,
    double min,
    double max, [
    String? fieldName,
  ]) {
    final numberValidation = validateNumber(value, fieldName);
    if (numberValidation != null) return numberValidation;
    
    final number = double.parse(value!.trim());
    if (number < min || number > max) {
      return '${fieldName ?? 'Value'} must be between $min and $max';
    }
    
    return null;
  }

  // ========== DATE VALIDATION ==========
  
  /// Validates date string format
  static String? validateDate(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Date'} is required';
    }
    
    try {
      DateTime.parse(value.trim());
      return null;
    } catch (e) {
      return 'Please enter a valid date';
    }
  }
  
  /// Validates date is not in the past
  static String? validateFutureDate(String? value, [String? fieldName]) {
    final dateValidation = validateDate(value, fieldName);
    if (dateValidation != null) return dateValidation;
    
    final date = DateTime.parse(value!.trim());
    final now = DateTime.now();
    
    if (date.isBefore(DateTime(now.year, now.month, now.day))) {
      return '${fieldName ?? 'Date'} cannot be in the past';
    }
    
    return null;
  }
  
  /// Validates date is not in the future
  static String? validatePastDate(String? value, [String? fieldName]) {
    final dateValidation = validateDate(value, fieldName);
    if (dateValidation != null) return dateValidation;
    
    final date = DateTime.parse(value!.trim());
    final now = DateTime.now();
    
    if (date.isAfter(DateTime(now.year, now.month, now.day))) {
      return '${fieldName ?? 'Date'} cannot be in the future';
    }
    
    return null;
  }

  // ========== TIME VALIDATION ==========
  
  /// Validates time in HH:MM format
  static String? validateTime(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Time'} is required';
    }
    
    final timePattern = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
    if (!timePattern.hasMatch(value.trim())) {
      return 'Please enter a valid time (HH:MM format)';
    }
    
    return null;
  }
  // Add these methods to ValidationUtils class
static String? validateProjectName(String? value) {
  return validateLength(value, 2, 100, 'Project name');
}

static String? validateTaskTitle(String? value) {
  return validateLength(value, 1, 200, 'Task title');
}

static String? validateDescription(String? value, {bool required = false}) {
  if (!required && (value == null || value.trim().isEmpty)) {
    return null;
  }
  return validateLength(value, 1, 1000, 'Description');
}

  // ========== CUSTOM VALIDATION ==========
  
  /// Validates field matches a specific pattern
  static String? validatePattern(
    String? value,
    RegExp pattern,
    String errorMessage, [
    String? fieldName,
  ]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    if (!pattern.hasMatch(value.trim())) {
      return errorMessage;
    }
    
    return null;
  }
  
  /// Validates field matches one of the allowed values
  static String? validateOptions(
    String? value,
    List<String> allowedValues, [
    String? fieldName,
  ]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    if (!allowedValues.contains(value.trim())) {
      return 'Please select a valid option';
    }
    
    return null;
  }

  // ========== COMPOSITE VALIDATORS ==========
  
  /// Combines multiple validators
  static String? Function(String?) combineValidators(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
  
  /// Creates a conditional validator
  static String? Function(String?) conditionalValidator(
    bool Function() condition,
    String? Function(String?) validator,
  ) {
    return (String? value) {
      if (condition()) {
        return validator(value);
      }
      return null;
    };
  }
}
  