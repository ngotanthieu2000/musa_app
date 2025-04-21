/// Base class for all exceptions in the app
import 'api_error_type.dart';

/// Base exception for all exceptions in the app
abstract class AppException implements Exception {
  /// User-friendly message for the exception
  final String message;
  
  /// Additional error details
  final String? details;
  
  /// Stack trace for the exception
  final StackTrace? stackTrace;
  
  /// Type of error
  final ApiErrorType errorType;
  
  /// Constructor
  const AppException({
    required this.message,
    this.details,
    this.stackTrace,
    this.errorType = ApiErrorType.unknown,
  });
  
  @override
  String toString() => 'AppException: $message ${details != null ? '($details)' : ''}';
}

/// Exception thrown when there is an error with the server
class ServerException extends AppException {
  /// HTTP status code
  final int? statusCode;
  
  /// Additional error data
  final dynamic data;
  
  /// Constructor
  const ServerException({
    required String message,
    required ApiErrorType errorType,
    this.data,
    this.statusCode,
    String? details,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         details: details,
         errorType: errorType,
         stackTrace: stackTrace,
       );
}

/// Exception thrown when there is a cache error
class CacheException extends AppException {
  /// Constructor
  const CacheException({
    String message = 'Cache error occurred',
    String? details,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         details: details,
         errorType: ApiErrorType.cache,
         stackTrace: stackTrace,
       );
}

/// Exception thrown when there is a network error
class NetworkException extends AppException {
  /// HTTP status code
  final int? statusCode;
  
  /// Constructor
  const NetworkException({
    required String message,
    String? details,
    required ApiErrorType errorType,
    StackTrace? stackTrace,
    this.statusCode,
  }) : super(
         message: message,
         details: details,
         errorType: errorType,
         stackTrace: stackTrace,
       );
}

/// Exception thrown when there is an authentication error
class AuthException extends AppException {
  /// Constructor
  const AuthException({
    String message = 'Authentication Error',
    String? details,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         details: details,
         stackTrace: stackTrace,
         errorType: ApiErrorType.auth,
       );
}

/// Exception thrown when there is a validation error
class ValidationException extends AppException {
  /// Field validation errors
  final Map<String, dynamic>? errors;
  
  /// Additional validation data
  final Map<String, dynamic>? validationErrors;
  
  /// Constructor
  const ValidationException({
    String message = 'Validation Error',
    this.errors,
    this.validationErrors,
    String? details,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         details: details,
         stackTrace: stackTrace,
         errorType: ApiErrorType.validation,
       );
}

/// Exception thrown when there is a timeout
class TimeoutException extends AppException {
  /// Constructor
  const TimeoutException({
    String message = 'Request Timeout',
    String? details,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         details: details,
         stackTrace: stackTrace,
         errorType: ApiErrorType.timeout,
       );
}

/// Exception thrown when a requested resource is not found
class NotFoundException extends AppException {
  /// Constructor
  const NotFoundException({
    String message = 'Resource Not Found',
    String? details,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         details: details,
         stackTrace: stackTrace,
         errorType: ApiErrorType.notFound,
       );
}

/// Exception for authentication errors related to user authentication
class AuthenticationException extends AppException {
  const AuthenticationException({
    String message = 'Lỗi xác thực người dùng',
    String? details,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
          errorType: ApiErrorType.auth,
        );

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Exception for unauthorized access
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    String message = 'Bạn không có quyền truy cập',
    String? details,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
          errorType: ApiErrorType.auth,
        );

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// Exception thrown when there's an unknown error
class UnknownException extends AppException {
  const UnknownException({
    String message = 'Đã xảy ra lỗi không xác định',
    String? details,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
          errorType: ApiErrorType.unknown,
        );
}

/// Exception thrown when there is a format error
class FormatException extends AppException {
  FormatException({
    String message = 'Format error occurred',
    String? details,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         details: details,
         errorType: ApiErrorType.unknown,
         stackTrace: stackTrace,
       );
} 