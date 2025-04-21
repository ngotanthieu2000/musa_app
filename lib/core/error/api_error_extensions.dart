import 'api_error_type.dart';

/// Extension on [ApiErrorType] to provide user-friendly messages.
extension ApiErrorTypeExtension on ApiErrorType {
  /// Returns a user-friendly message based on the error type.
  String get userFriendlyMessage {
    switch (this) {
      case ApiErrorType.server:
        return 'There was a problem with our servers. Please try again later.';
      case ApiErrorType.client:
        return 'There was a problem with your request. Please check your input and try again.';
      case ApiErrorType.auth:
        return 'Authentication failed. Please check your credentials or login again.';
      case ApiErrorType.validation:
        return 'Some of the information you provided is invalid. Please check and try again.';
      case ApiErrorType.notFound:
        return 'The requested resource could not be found.';
      case ApiErrorType.network:
        return 'Network connection error. Please check your internet connection and try again.';
      case ApiErrorType.timeout:
        return 'The request timed out. Please try again later.';
      case ApiErrorType.cache:
        return 'There was a problem retrieving cached data.';
      case ApiErrorType.cors:
        return 'Cross-origin request blocked. Please try again or contact support.';
      case ApiErrorType.unknown:
        return 'An unknown error occurred. Please try again later.';
    }
  }
} 