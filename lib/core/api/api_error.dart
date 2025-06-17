class ApiError implements Exception {
  final int? statusCode;
  final String message;
  final dynamic data;

  ApiError({
    this.statusCode,
    required this.message,
    this.data,
  });

  @override
  String toString() {
    return 'ApiError: $message (Status Code: $statusCode)';
  }

  // Helper method to extract validation errors from response data
  Map<String, List<String>> getValidationErrors() {
    final Map<String, List<String>> errors = {};
    
    if (data != null && data is Map && data.containsKey('errors')) {
      final errorsData = data['errors'];
      if (errorsData is Map) {
        errorsData.forEach((key, value) {
          if (value is List) {
            errors[key] = List<String>.from(value);
          } else if (value is String) {
            errors[key] = [value];
          }
        });
      }
    }
    
    return errors;
  }

  // Get a user-friendly error message
  String getUserFriendlyMessage() {
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input and try again.';
      case 401:
        return 'Your session has expired. Please log in again.';
      case 403:
        return 'You do not have permission to perform this action.';
      case 404:
        return 'The requested resource was not found.';
      case 422:
        return 'Validation error. Please check your input and try again.';
      case 500:
      case 502:
      case 503:
      case 504:
        return 'Server error. Please try again later.';
      case 0:
        return 'No internet connection. Please check your network.';
      default:
        return message;
    }
  }
}
