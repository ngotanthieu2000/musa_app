import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/motivation_factor.dart';
import '../repositories/persona_repository.dart';

class UpdateMotivationFactorsParams {
  final List<MotivationFactor> factors;

  UpdateMotivationFactorsParams({required this.factors});
}

class UpdateMotivationFactors implements UseCase<List<MotivationFactor>, UpdateMotivationFactorsParams> {
  final PersonaRepository repository;

  UpdateMotivationFactors(this.repository);

  @override
  Future<Either<Failure, List<MotivationFactor>>> call(UpdateMotivationFactorsParams params) async {
    return await repository.updateMotivationFactors(params.factors);
  }
}
