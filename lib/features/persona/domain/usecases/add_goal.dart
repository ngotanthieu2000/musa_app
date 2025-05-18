import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/goal.dart';
import '../repositories/persona_repository.dart';

/// Parameters for adding a goal
class AddGoalParams {
  final Goal goal;

  AddGoalParams({required this.goal});
}

/// Use case to add a new goal for the current user
class AddGoal implements UseCase<Goal, AddGoalParams> {
  final PersonaRepository repository;

  AddGoal(this.repository);

  @override
  Future<Either<Failure, Goal>> call(AddGoalParams params) async {
    return await repository.addGoal(params.goal);
  }
}
