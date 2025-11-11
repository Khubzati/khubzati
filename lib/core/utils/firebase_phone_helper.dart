/// Firebase Phone Authentication Helper
///
/// Provides utilities for handling Firebase phone authentication,
/// including support for test phone numbers and region-specific handling.
library;

class FirebasePhoneHelper {
  /// Firebase test phone numbers that work without region enablement
  /// Format: +1 650-555-3434 (any country code + 6505553434)
  /// Test code: 123456
  static const List<String> testPhoneNumbers = [
    '+16505553434', // US test number
    '+16505551234', // US test number
    '+16505559999', // US test number
  ];

  /// Check if a phone number is a Firebase test number
  static bool isTestPhoneNumber(String phoneNumber) {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[\s\-]'), '');
    // Firebase test numbers: any country code + 650555XXXX
    return cleaned.contains('650555');
  }

  /// Get the test verification code for test phone numbers
  /// Firebase always returns "123456" for test numbers
  static String getTestVerificationCode() => '123456';

  /// Format phone number for Jordan (+962)
  /// Ensures proper E.164 format
  static String formatJordanPhoneNumber(String phone) {
    String formatted = phone.trim().replaceAll(RegExp(r'[\s\-]'), '');

    if (!formatted.startsWith('+')) {
      if (formatted.startsWith('962')) {
        formatted = '+$formatted';
      } else if (formatted.startsWith('0')) {
        // Remove leading 0 and add +962
        formatted = '+962${formatted.substring(1)}';
      } else {
        // Default: add +962 for Jordan
        formatted = '+962$formatted';
      }
    }

    return formatted;
  }

  /// Validate Jordan phone number format
  /// Jordan numbers: +962 7 XXXX XXXX (9 digits after country code)
  static bool isValidJordanPhoneNumber(String phone) {
    final formatted = formatJordanPhoneNumber(phone);

    // Check if it's a test number first
    if (isTestPhoneNumber(formatted)) {
      return true;
    }

    // Jordan format: +962 followed by 9 digits (starting with 7)
    final jordanPattern = RegExp(r'^\+9627\d{8}$');
    return jordanPattern.hasMatch(formatted);
  }

  /// Get user-friendly error message for Firebase phone auth errors
  static String getErrorMessage(String errorCode, {String? defaultMessage}) {
    switch (errorCode) {
      case 'invalid-phone-number':
        return 'Invalid phone number. Please check and try again.';

      case 'operation-not-allowed':
        return 'SMS verification for Jordan (+962) is not enabled in Firebase Console.\n\n'
            'To enable it:\n'
            '1. Go to Firebase Console → Authentication → Settings\n'
            '2. Click on "Phone numbers" tab\n'
            '3. Enable "Jordan (+962)" in the allowed countries list\n'
            '4. Save changes\n\n'
            'For testing, you can use test numbers: +1 650-555-XXXX (code: 123456)';

      case 'too-many-requests':
        return 'Too many verification attempts from this device.\n\n'
            'Firebase has temporarily blocked requests due to unusual activity.\n\n'
            'Please wait 15-30 minutes before trying again.\n\n'
            'Tip: Use a test phone number (+1 650-555-XXXX) with code 123456 for development.';

      case 'quota-exceeded':
        return 'SMS quota exceeded. Please contact support or enable Jordan in Firebase Console.';

      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';

      case 'missing-client-identifier':
      case 'app-not-authorized':
        return 'Firebase configuration error. Please check your Firebase setup and ensure APNs is configured.';

      case 'invalid-verification-code':
        return 'Invalid verification code. Please check and try again.';

      case 'session-expired':
        return 'Verification session expired. Please request a new code.';

      case 'internal-error':
        return 'Firebase authentication configuration error.\n\n'
            'On iOS, this usually means:\n'
            '• Missing OAuth Client ID in GoogleService-Info.plist\n'
            '• APNs (Apple Push Notification) not configured\n'
            '• Phone authentication not enabled for your country\n\n'
            'Quick Fix Options:\n'
            '1. Use test phone number: +1 650-555-3434 (code: 123456)\n'
            '2. Check FIREBASE_CONFIG_STATUS.md for setup instructions\n'
            '3. Verify GoogleService-Info.plist has real CLIENT_ID values\n\n'
            'For production, you need:\n'
            '• Complete GoogleService-Info.plist with OAuth credentials\n'
            '• APNs certificate uploaded to Firebase Console';

      default:
        return defaultMessage ?? 'Phone verification failed. Please try again.';
    }
  }

  /// Check if we should show instructions for enabling Jordan
  static bool shouldShowEnableInstructions(String errorCode) {
    return errorCode == 'operation-not-allowed';
  }
}
