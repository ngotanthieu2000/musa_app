// lib/core/error/failures.dart
import 'package:equatable/equatable.dart';
import 'api_error_type.dart';
import 'api_error_extensions.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  /// User-friendly message
  final String message;
  
  /// Error type
  final ApiErrorType errorType;
  
  /// Additional data
  final dynamic data;

  /// Constructor
  const Failure({
    required this.message,
    required this.errorType,
    this.data,
  });
  
  @override
  List<Object?> get props => [message, errorType, data];
  
  @override
  String toString() => '$runtimeType: $message';
  
  /// Get user-friendly message
  String get userFriendlyMessage => errorType.userFriendlyMessage;
}

/// Server failure when there is a problem with the server
class ServerFailure extends Failure {
  /// Constructor
  const ServerFailure({
    required String message,
    required ApiErrorType errorType,
    dynamic data,
  }) : super(
          message: message,
          errorType: errorType,
          data: data,
        );
}

/// Network failure when there is a problem with the network
class NetworkFailure extends Failure {
  /// Constructor
  const NetworkFailure({
    required String message,
    required ApiErrorType errorType,
    dynamic data,
  }) : super(
          message: message,
          errorType: errorType,
          data: data,
        );
}

/// Cache failure when there is a problem with the cache
class CacheFailure extends Failure {
  /// Constructor
  const CacheFailure({
    required String message,
    ApiErrorType errorType = ApiErrorType.cache,
    dynamic data,
  }) : super(
          message: message,
          errorType: errorType,
          data: data,
        );
}

/// Validation failure when there is a problem with validation
class ValidationFailure extends Failure {
  /// Validation errors
  final Map<String, List<String>>? errors;

  /// Constructor
  const ValidationFailure({
    required String message,
    ApiErrorType errorType = ApiErrorType.validation,
    this.errors,
    dynamic data,
  }) : super(
          message: message,
          errorType: errorType,
          data: data,
        );
  
  @override
  List<Object?> get props => [...super.props, errors];
}

/// Auth failure when there is a problem with authentication
class AuthFailure extends Failure {
  /// Constructor
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

/// Unexpected failure
class UnexpectedFailure extends Failure {
  /// Constructor
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
