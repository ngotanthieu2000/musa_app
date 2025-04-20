// lib/core/error/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  
  const Failure({required this.message});
  
  @override
  List<Object> get props => [message];
}

// Server errors
class ServerFailure extends Failure {
  const ServerFailure({required String message}) : super(message: message);
}

// Network connectivity errors
class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message: message);
}

// Authentication errors
class AuthFailure extends Failure {
  const AuthFailure({required String message}) : super(message: message);
}

// Local data storage errors
class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}

// Undefined errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required String message}) : super(message: message);
}
