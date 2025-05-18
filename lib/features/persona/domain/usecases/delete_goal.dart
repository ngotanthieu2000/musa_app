import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/persona_repository.dart';

class DeleteGoalParams {
  final String goalId;

  DeleteGoalParams({required this.goalId});
}

class DeleteGoal implements UseCase<bool, DeleteGoalParams> {
  final PersonaRepository repository;

  DeleteGoal(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteGoalParams params) async {
    return await repository.deleteGoal(params.goalId);
  }
}
