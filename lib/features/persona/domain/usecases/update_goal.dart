import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/goal.dart';
import '../repositories/persona_repository.dart';

class UpdateGoalParams {
  final Goal goal;

  UpdateGoalParams({required this.goal});
}

class UpdateGoal implements UseCase<Goal, UpdateGoalParams> {
  final PersonaRepository repository;

  UpdateGoal(this.repository);

  @override
  Future<Either<Failure, Goal>> call(UpdateGoalParams params) async {
    return await repository.updateGoal(params.goal);
  }
}
