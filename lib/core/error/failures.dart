// lib/core/error/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? details;

  const Failure({
    required this.message,
    this.details,
  });

  @override
  List<Object?> get props => [message, details];
}

// Lỗi mạng
class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'Không thể kết nối đến máy chủ',
    String? details,
  }) : super(message: message, details: details);
}

// Lỗi máy chủ
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    String message = 'Đã xảy ra lỗi máy chủ',
    String? details,
    this.statusCode,
  }) : super(message: message, details: details);

  @override
  List<Object?> get props => [message, details, statusCode];
}

// Lỗi cache
class CacheFailure extends Failure {
  const CacheFailure({
    String message = 'Không thể đọc dữ liệu từ bộ nhớ',
    String? details,
  }) : super(message: message, details: details);
}

// Lỗi xác thực
class AuthFailure extends Failure {
  const AuthFailure({
    String message = 'Lỗi xác thực',
    String? details,
  }) : super(message: message, details: details);
}

// Lỗi đầu vào không hợp lệ
class InvalidInputFailure extends Failure {
  const InvalidInputFailure({
    String message = 'Dữ liệu đầu vào không hợp lệ',
    String? details,
  }) : super(message: message, details: details);
}

// Lỗi quyền truy cập
class PermissionFailure extends Failure {
  const PermissionFailure({
    String message = 'Không có quyền thực hiện hành động này',
    String? details,
  }) : super(message: message, details: details);
}

// Lỗi chưa đăng nhập
class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure({
    String message = 'Vui lòng đăng nhập để tiếp tục',
    String? details,
  }) : super(message: message, details: details);
}

// Lỗi chưa được phân quyền
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    String message = 'Bạn không có quyền thực hiện hành động này',
    String? details,
  }) : super(message: message, details: details);
}

// Lỗi từ Firebase hoặc dịch vụ ngoài
class ExternalServiceFailure extends Failure {
  const ExternalServiceFailure({
    String message = 'Lỗi từ dịch vụ bên ngoài',
    String? details,
  }) : super(message: message, details: details);
}

// Lỗi không tìm thấy dữ liệu
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    String message = 'Không tìm thấy dữ liệu',
    String? details,
  }) : super(message: message, details: details);
}

// Lỗi không xác định
class UnknownFailure extends Failure {
  const UnknownFailure({
    String message = 'Đã xảy ra lỗi không xác định',
    String? details,
  }) : super(message: message, details: details);
}
