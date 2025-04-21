import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

@injectable
class UpdateProfile implements UseCase<Profile, Map<String, dynamic>> {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  @override
  Future<Either<Failure, Profile>> call(Map<String, dynamic> params) async {
    return await repository.updateProfile(params);
  }
} 