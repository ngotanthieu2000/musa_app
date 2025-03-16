// lib/core/error/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

// Lỗi liên quan đến server
class ServerFailure extends Failure {
  const ServerFailure({String message = 'Server error'})
    : super(message: message);
}

// Lỗi liên quan đến cache
class CacheFailure extends Failure {
  const CacheFailure({String message = 'Cache error'})
    : super(message: message);
}

// Lỗi liên quan đến kết nối mạng
class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'Network error'})
    : super(message: message);
}
