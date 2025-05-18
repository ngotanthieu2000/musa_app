import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/personality.dart';
import '../repositories/persona_repository.dart';

class UpdatePersonalityParams {
  final Personality personality;

  UpdatePersonalityParams({required this.personality});
}

class UpdatePersonality implements UseCase<Personality, UpdatePersonalityParams> {
  final PersonaRepository repository;

  UpdatePersonality(this.repository);

  @override
  Future<Either<Failure, Personality>> call(UpdatePersonalityParams params) async {
    return await repository.updatePersonality(params.personality);
  }
}
