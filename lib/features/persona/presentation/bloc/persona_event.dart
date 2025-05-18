part of 'persona_bloc.dart';

abstract class PersonaEvent extends Equatable {
  const PersonaEvent();

  @override
  List<Object?> get props => [];
}

class GetPersonaEvent extends PersonaEvent {}

class UpdatePersonaEvent extends PersonaEvent {
  final Persona persona;

  const UpdatePersonaEvent(this.persona);

  @override
  List<Object?> get props => [persona];
}

class RecordEmotionalStateEvent extends PersonaEvent {
  final EmotionalState state;

  const RecordEmotionalStateEvent(this.state);

  @override
  List<Object?> get props => [state];
}

class AddGoalEvent extends PersonaEvent {
  final Goal goal;

  const AddGoalEvent(this.goal);

  @override
  List<Object?> get props => [goal];
}

class UpdateGoalEvent extends PersonaEvent {
  final Goal goal;

  const UpdateGoalEvent(this.goal);

  @override
  List<Object?> get props => [goal];
}

class DeleteGoalEvent extends PersonaEvent {
  final String goalId;

  const DeleteGoalEvent(this.goalId);

  @override
  List<Object?> get props => [goalId];
}

class UpdatePersonalityEvent extends PersonaEvent {
  final Personality personality;

  const UpdatePersonalityEvent(this.personality);

  @override
  List<Object?> get props => [personality];
}

class UpdateInteractionPreferenceEvent extends PersonaEvent {
  final InteractionPreference preference;

  const UpdateInteractionPreferenceEvent(this.preference);

  @override
  List<Object?> get props => [preference];
}

class UpdateMotivationFactorsEvent extends PersonaEvent {
  final List<MotivationFactor> factors;

  const UpdateMotivationFactorsEvent(this.factors);

  @override
  List<Object?> get props => [factors];
}

class GenerateInsightsEvent extends PersonaEvent {}

class AnalyzeWithAIAdvisorEvent extends PersonaEvent {
  final String input;

  const AnalyzeWithAIAdvisorEvent(this.input);

  @override
  List<Object?> get props => [input];
}
