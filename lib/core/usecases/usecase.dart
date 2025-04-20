import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Interface cho tất cả các use case
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case không có tham số
class NoParams {
  const NoParams();
}

class RefreshTokenParams {
  final String refreshToken;
  
  const RefreshTokenParams({required this.refreshToken});
} 