import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

/// Interface cho tất cả các use case
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case không có tham số
class NoParams extends Equatable {
  const NoParams();
  
  @override
  List<Object> get props => [];
} 