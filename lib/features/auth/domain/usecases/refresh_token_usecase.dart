import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

class RefreshTokenUseCase implements UseCase<AuthTokens, RefreshTokenParams> {
  final AuthRepository repository;
  
  RefreshTokenUseCase(this.repository);
  
  @override
  Future<Either<Failure, AuthTokens>> call(RefreshTokenParams params) async {
    return await repository.refreshToken(refreshToken: params.refreshToken);
  }
} 