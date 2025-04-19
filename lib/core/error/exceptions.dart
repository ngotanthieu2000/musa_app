/// Base class for all exceptions in the app
class AppException implements Exception {
  final String message;
  final String? details;
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    this.details,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'AppException: $message${details != null ? '\nDetails: $details' : ''}';
  }
}

/// Exception thrown when there's a server error
class ServerException extends AppException {
  final int? statusCode;

  ServerException({
    String message = 'Đã xảy ra lỗi máy chủ',
    String? details,
    this.statusCode,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
        );
}

/// Exception thrown when there's a network error
class NetworkException extends AppException {
  NetworkException({
    String message = 'Không thể kết nối đến máy chủ',
    String? details,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
        );
}

/// Exception thrown when a resource is not found
class NotFoundException extends AppException {
  NotFoundException({
    String message = 'Không tìm thấy tài nguyên',
    String? details,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
        );
}

/// Exception thrown when there's a cache error
class CacheException extends AppException {
  CacheException({
    String message = 'Lỗi bộ nhớ cache',
    String? details,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
        );
}

/// Exception thrown when user is not authenticated
class UnauthenticatedException extends AppException {
  UnauthenticatedException({
    String message = 'Vui lòng đăng nhập để tiếp tục',
    String? details,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
        );
}

/// Exception thrown when user is not authorized
class UnauthorizedException extends AppException {
  UnauthorizedException({
    String message = 'Bạn không có quyền truy cập',
    String? details,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
        );
}

/// Exception thrown when user input is invalid
class ValidationException extends AppException {
  final Map<String, String>? errors;

  ValidationException({
    String message = 'Dữ liệu không hợp lệ',
    String? details,
    this.errors,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
        );
}

/// Exception thrown when there's an error in Firebase
class FirebaseException extends AppException {
  final String? code;

  FirebaseException({
    String message = 'Lỗi Firebase',
    String? details,
    this.code,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
        );
}

/// Exception thrown when there's a timeout
class TimeoutException extends AppException {
  TimeoutException({
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
  UnknownException({
    String message = 'Đã xảy ra lỗi không xác định',
    String? details,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
        );
} 