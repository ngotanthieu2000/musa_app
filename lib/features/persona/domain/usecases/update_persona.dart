import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/persona.dart';
import '../repositories/persona_repository.dart';

class UpdatePersonaParams {
  final Persona persona;

  UpdatePersonaParams({required this.persona});
}

class UpdatePersona implements UseCase<Persona, UpdatePersonaParams> {
  final PersonaRepository repository;

  UpdatePersona(this.repository);

  @override
  Future<Either<Failure, Persona>> call(UpdatePersonaParams params) async {
    return await repository.updatePersona(params.persona);
  }
}
