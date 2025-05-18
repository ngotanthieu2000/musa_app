import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/persona_repository.dart';

class GenerateInsights implements UseCase<List<String>, NoParams> {
  final PersonaRepository repository;

  GenerateInsights(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await repository.generateInsights();
  }
}
