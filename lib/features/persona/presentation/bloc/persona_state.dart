part of 'persona_bloc.dart';

abstract class PersonaState extends Equatable {
  const PersonaState();

  @override
  List<Object?> get props => [];
}

class PersonaInitial extends PersonaState {}

class PersonaLoading extends PersonaState {}

class PersonaLoaded extends PersonaState {
  final Persona persona;

  const PersonaLoaded(this.persona);

  @override
  List<Object?> get props => [persona];
}

class PersonaError extends PersonaState {
  final String message;

  const PersonaError({required this.message});

  @override
  List<Object?> get props => [message];
}

class EmotionalStateRecorded extends PersonaState {
  final EmotionalState state;

  const EmotionalStateRecorded(this.state);

  @override
  List<Object?> get props => [state];
}

class GoalAdded extends PersonaState {
  final Goal goal;

  const GoalAdded(this.goal);

  @override
  List<Object?> get props => [goal];
}

class GoalUpdated extends PersonaState {
  final Goal goal;

  const GoalUpdated(this.goal);

  @override
  List<Object?> get props => [goal];
}

class GoalDeleted extends PersonaState {
  final String goalId;

  const GoalDeleted(this.goalId);

  @override
  List<Object?> get props => [goalId];
}

class PersonalityUpdated extends PersonaState {
  final Personality personality;

  const PersonalityUpdated(this.personality);

  @override
  List<Object?> get props => [personality];
}

class InteractionPreferenceUpdated extends PersonaState {
  final InteractionPreference preference;

  const InteractionPreferenceUpdated(this.preference);

  @override
  List<Object?> get props => [preference];
}

class MotivationFactorsUpdated extends PersonaState {
  final List<MotivationFactor> factors;

  const MotivationFactorsUpdated(this.factors);

  @override
  List<Object?> get props => [factors];
}

class InsightsGenerated extends PersonaState {
  final List<String> insights;

  const InsightsGenerated(this.insights);

  @override
  List<Object?> get props => [insights];
}

class AIAdvisorAnalysisLoaded extends PersonaState {
  final AIAdvisorAnalysis analysis;

  const AIAdvisorAnalysisLoaded(this.analysis);

  @override
  List<Object?> get props => [analysis];
}
