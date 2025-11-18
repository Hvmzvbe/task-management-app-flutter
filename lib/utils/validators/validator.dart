class TValidator {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    // Check for minimum password length
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }

    // Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }

  // Phone number validation
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    // Regular expression for phone number validation (assuming a 10-digit US phone number format)
    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (10 digits required).';
    }

    return null;
  }

  // Generic empty field validation
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  // Username validation
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required.';
    }

    if (value.length < 3) {
      return 'Username must be at least 3 characters long.';
    }

    // Check for valid characters (alphanumeric and underscores)
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores.';
    }

    return null;
  }

  // Credit card number validation (basic check)
  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit card number is required.';
    }

    // Remove spaces and dashes
    final cleanedValue = value.replaceAll(RegExp(r'[\s-]'), '');

    // Check if it contains only digits
    if (!RegExp(r'^\d+$').hasMatch(cleanedValue)) {
      return 'Invalid credit card number.';
    }

    // Check length (most cards are 13-19 digits)
    if (cleanedValue.length < 13 || cleanedValue.length > 19) {
      return 'Credit card number must be between 13 and 19 digits.';
    }

    return null;
  }

  // CVV validation
  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required.';
    }

    // Check if it contains only digits
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'CVV must contain only digits.';
    }

    // Check length (3 or 4 digits)
    if (value.length < 3 || value.length > 4) {
      return 'CVV must be 3 or 4 digits.';
    }

    return null;
  }

  // Date validation (format: MM/YY or MM/YYYY)
  static String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required.';
    }

    // Regular expression for MM/YY or MM/YYYY format
    final dateRegExp = RegExp(r'^(0[1-9]|1[0-2])\/(\d{2}|\d{4})$');

    if (!dateRegExp.hasMatch(value)) {
      return 'Invalid date format (MM/YY or MM/YYYY).';
    }

    // Extract month and year
    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse(parts[1]);

    // Adjust year if it's in YY format
    final currentYear = DateTime.now().year;
    final fullYear = year < 100 ? 2000 + year : year;

    // Check if the card is expired
    final currentMonth = DateTime.now().month;
    if (fullYear < currentYear || (fullYear == currentYear && month < currentMonth)) {
      return 'Card has expired.';
    }

    return null;
  }

  // URL validation
  static String? validateURL(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required.';
    }

    // Regular expression for URL validation
    final urlRegExp = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );

    if (!urlRegExp.hasMatch(value)) {
      return 'Invalid URL format.';
    }

    return null;
  }
}
