import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/interaction_preference.dart';
import '../repositories/persona_repository.dart';

class UpdateInteractionPreferenceParams {
  final InteractionPreference preference;

  UpdateInteractionPreferenceParams({required this.preference});
}

class UpdateInteractionPreference implements UseCase<InteractionPreference, UpdateInteractionPreferenceParams> {
  final PersonaRepository repository;

  UpdateInteractionPreference(this.repository);

  @override
  Future<Either<Failure, InteractionPreference>> call(UpdateInteractionPreferenceParams params) async {
    return await repository.updateInteractionPreference(params.preference);
  }
}
