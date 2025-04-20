/// Base class for all exceptions in the app
class AppException implements Exception {
  final String message;
  final String? details;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.details,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'AppException: $message${details != null ? '\nDetails: $details' : ''}';
  }
}

/// Exception for server-related errors
class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    String message = 'Đã xảy ra lỗi máy chủ',
    String? details,
    this.statusCode,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
        );

  @override
  String toString() => 'ServerException: $message (statusCode: $statusCode)';
}

/// Exception for cache-related errors
class CacheException extends AppException {
  const CacheException({
    String message = 'Lỗi bộ nhớ cache',
    String? details,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
        );

  @override
  String toString() => 'CacheException: $message';
}

/// Exception for authentication errors
class AuthException extends AppException {
  const AuthException({
    String message = 'Lỗi xác thực',
    String? details,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
        );

  @override
  String toString() => 'AuthException: $message';
}

/// Exception for network errors
class NetworkException extends AppException {
  final int statusCode;

  const NetworkException({
    String message = 'Không thể kết nối đến máy chủ',
    String? details,
    StackTrace? stackTrace,
    required this.statusCode,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
        );

  @override
  String toString() => 'NetworkException: $message (statusCode: $statusCode)';
}

/// Exception for validation errors
class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  const ValidationException({
    String message = 'Dữ liệu không hợp lệ',
    String? details,
    this.errors,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
        );

  @override
  String toString() {
    if (errors != null && errors!.isNotEmpty) {
      return 'ValidationException: $message, errors: $errors';
    }
    return 'ValidationException: $message';
  }
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
        );

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// Exception thrown when there's a timeout
class TimeoutException extends AppException {
  const TimeoutException({
    String message = 'Quá thời gian xử lý yêu cầu',
    String? details,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
        );
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
        );
} 