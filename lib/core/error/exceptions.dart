/// Base class for all exceptions in the app
import 'api_error_type.dart';

class AppException implements Exception {
  final String message;
  final String? details;
  final StackTrace? stackTrace;
  final ApiErrorType errorType;

  const AppException({
    required this.message,
    this.details,
    this.stackTrace,
    this.errorType = ApiErrorType.unknown,
  });

  String get userFriendlyMessage {
    switch (errorType) {
      case ApiErrorType.network:
        return 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet và thử lại.';
      case ApiErrorType.server:
        return 'Lỗi máy chủ. Vui lòng thử lại sau.';
      case ApiErrorType.auth:
        return 'Lỗi xác thực. Vui lòng đăng nhập lại.';
      case ApiErrorType.validation:
        return message; // Giữ nguyên thông báo gốc cho lỗi xác thực dữ liệu
      case ApiErrorType.notFound:
        return 'Không tìm thấy tài nguyên yêu cầu.';
      case ApiErrorType.timeout:
        return 'Yêu cầu đã hết thời gian. Vui lòng thử lại.';
      case ApiErrorType.cors:
        return 'Lỗi CORS. Máy chủ không cho phép truy cập từ ứng dụng này.';
      case ApiErrorType.unknown:
      default:
        return 'Đã xảy ra lỗi không xác định. Vui lòng thử lại.';
    }
  }

  @override
  String toString() {
    return 'AppException: $message${details != null ? '\nDetails: $details' : ''}';
  }
}

/// Exception for server-related errors
class ServerException extends AppException {
  final int? statusCode;
  final dynamic data;

  const ServerException({
    String message = 'Đã xảy ra lỗi máy chủ',
    String? details,
    this.statusCode,
    StackTrace? stackTrace,
    ApiErrorType errorType = ApiErrorType.server,
    this.data,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
          errorType: errorType,
        );

  @override
  String toString() => 'ServerException: $message (statusCode: $statusCode, type: $errorType)';
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
          errorType: ApiErrorType.auth,
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
    ApiErrorType errorType = ApiErrorType.network,
  }) : super(
          message: message,
          details: details,
          stackTrace: stackTrace,
          errorType: errorType,
        );

  @override
  String toString() => 'NetworkException: $message (statusCode: $statusCode, type: $errorType)';
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
          errorType: ApiErrorType.validation,
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
          errorType: ApiErrorType.auth,
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
          errorType: ApiErrorType.timeout,
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
          errorType: ApiErrorType.unknown,
        );
} 