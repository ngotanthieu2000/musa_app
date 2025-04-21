import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/profile_repository.dart';

@injectable
class ChangePassword {
  final ProfileRepository repository;

  ChangePassword(this.repository);

  Future<Either<Failure, bool>> call({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await repository.changePassword(currentPassword, newPassword);
  }
} 