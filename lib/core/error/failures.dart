// lib/core/error/failures.dart
import 'package:equatable/equatable.dart';
import 'api_error_type.dart';

abstract class Failure extends Equatable {
  final String message;
  final ApiErrorType errorType;
  final dynamic data;
  
  const Failure({
    required this.message, 
    this.errorType = ApiErrorType.unknown,
    this.data,
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
  List<Object?> get props => [message, errorType, data];
}

// Server errors
class ServerFailure extends Failure {
  final int? statusCode;
  
  const ServerFailure({
    required String message, 
    this.statusCode,
    ApiErrorType errorType = ApiErrorType.server,
    dynamic data,
  }) : super(
        message: message, 
        errorType: errorType,
        data: data,
      );
      
  @override
  List<Object?> get props => [...super.props, statusCode];
}

// Network connectivity errors
class NetworkFailure extends Failure {
  const NetworkFailure({
    required String message,
    ApiErrorType errorType = ApiErrorType.network,
    dynamic data,
  }) : super(
        message: message,
        errorType: errorType,
        data: data,
      );
}

// Authentication errors
class AuthFailure extends Failure {
  const AuthFailure({
    required String message,
    ApiErrorType errorType = ApiErrorType.auth,
    dynamic data,
  }) : super(
        message: message,
        errorType: errorType,
        data: data,
      );
}

// Local data storage errors
class CacheFailure extends Failure {
  const CacheFailure({
    required String message,
    dynamic data,
  }) : super(
        message: message,
        errorType: ApiErrorType.unknown,
        data: data,
      );
}

// Validation errors
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;
  
  const ValidationFailure({
    required String message,
    this.errors,
    dynamic data,
  }) : super(
        message: message,
        errorType: ApiErrorType.validation,
        data: data,
      );
  
  @override
  List<Object?> get props => [...super.props, errors];
}

// Undefined errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    required String message,
    ApiErrorType errorType = ApiErrorType.unknown,
    dynamic data,
  }) : super(
        message: message,
        errorType: errorType,
        data: data,
      );
}
