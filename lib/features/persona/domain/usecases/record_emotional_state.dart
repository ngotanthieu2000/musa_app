import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/emotional_state.dart';
import '../repositories/persona_repository.dart';

/// Parameters for recording an emotional state
class RecordEmotionalStateParams {
  final EmotionalState state;

  RecordEmotionalStateParams({required this.state});
}

/// Use case to record a new emotional state for the current user
class RecordEmotionalState implements UseCase<EmotionalState, RecordEmotionalStateParams> {
  final PersonaRepository repository;

  RecordEmotionalState(this.repository);

  @override
  Future<Either<Failure, EmotionalState>> call(RecordEmotionalStateParams params) async {
    return await repository.recordEmotionalState(params.state);
  }
}
