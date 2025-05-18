import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/persona.dart';
import '../repositories/persona_repository.dart';

/// Use case to get the persona for the current user
class GetPersona implements UseCase<Persona, NoParams> {
  final PersonaRepository repository;

  GetPersona(this.repository);

  @override
  Future<Either<Failure, Persona>> call(NoParams params) async {
    return await repository.getPersona();
  }
}
