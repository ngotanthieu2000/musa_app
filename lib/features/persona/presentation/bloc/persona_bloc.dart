import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/persona.dart';
import '../../domain/entities/emotional_state.dart';
import '../../domain/entities/goal.dart';
import '../../domain/entities/personality.dart';
import '../../domain/entities/interaction_preference.dart';
import '../../domain/entities/motivation_factor.dart';
import '../../domain/entities/ai_advisor_analysis.dart';
import '../../domain/usecases/get_persona.dart';
import '../../domain/usecases/update_persona.dart';
import '../../domain/usecases/record_emotional_state.dart';
import '../../domain/usecases/add_goal.dart';
import '../../domain/usecases/update_goal.dart';
import '../../domain/usecases/delete_goal.dart';
import '../../domain/usecases/update_personality.dart';
import '../../domain/usecases/update_interaction_preference.dart';
import '../../domain/usecases/update_motivation_factors.dart';
import '../../domain/usecases/generate_insights.dart';
import '../../domain/usecases/analyze_with_ai_advisor.dart';
import '../../../../core/usecases/usecase.dart';

part 'persona_event.dart';
part 'persona_state.dart';

class PersonaBloc extends Bloc<PersonaEvent, PersonaState> {
  final GetPersona getPersona;
  final UpdatePersona updatePersona;
  final RecordEmotionalState recordEmotionalState;
  final AddGoal addGoal;
  final UpdateGoal updateGoal;
  final DeleteGoal deleteGoal;
  final UpdatePersonality updatePersonality;
  final UpdateInteractionPreference updateInteractionPreference;
  final UpdateMotivationFactors updateMotivationFactors;
  final GenerateInsights generateInsights;
  final AnalyzeWithAIAdvisor analyzeWithAIAdvisor;

  PersonaBloc({
    required this.getPersona,
    required this.updatePersona,
    required this.recordEmotionalState,
    required this.addGoal,
    required this.updateGoal,
    required this.deleteGoal,
    required this.updatePersonality,
    required this.updateInteractionPreference,
    required this.updateMotivationFactors,
    required this.generateInsights,
    required this.analyzeWithAIAdvisor,
  }) : super(PersonaInitial()) {
    on<GetPersonaEvent>(_onGetPersona);
    on<UpdatePersonaEvent>(_onUpdatePersona);
    on<RecordEmotionalStateEvent>(_onRecordEmotionalState);
    on<AddGoalEvent>(_onAddGoal);
    on<UpdateGoalEvent>(_onUpdateGoal);
    on<DeleteGoalEvent>(_onDeleteGoal);
    on<UpdatePersonalityEvent>(_onUpdatePersonality);
    on<UpdateInteractionPreferenceEvent>(_onUpdateInteractionPreference);
    on<UpdateMotivationFactorsEvent>(_onUpdateMotivationFactors);
    on<GenerateInsightsEvent>(_onGenerateInsights);
    on<AnalyzeWithAIAdvisorEvent>(_onAnalyzeWithAIAdvisor);
  }

  Future<void> _onGetPersona(
    GetPersonaEvent event,
    Emitter<PersonaState> emit,
  ) async {
    emit(PersonaLoading());
    final result = await getPersona(NoParams());
    emit(result.fold(
      (failure) => PersonaError(message: failure.message),
      (persona) => PersonaLoaded(persona),
    ));
  }

  Future<void> _onUpdatePersona(
    UpdatePersonaEvent event,
    Emitter<PersonaState> emit,
  ) async {
    emit(PersonaLoading());
    final result = await updatePersona(UpdatePersonaParams(persona: event.persona));
    emit(result.fold(
      (failure) => PersonaError(message: failure.message),
      (persona) => PersonaLoaded(persona),
    ));
  }

  Future<void> _onRecordEmotionalState(
    RecordEmotionalStateEvent event,
    Emitter<PersonaState> emit,
  ) async {
    emit(PersonaLoading());
    final result = await recordEmotionalState(RecordEmotionalStateParams(state: event.state));
    emit(result.fold(
      (failure) => PersonaError(message: failure.message),
      (state) => EmotionalStateRecorded(state),
    ));
  }

  Future<void> _onAddGoal(
    AddGoalEvent event,
    Emitter<PersonaState> emit,
  ) async {
    emit(PersonaLoading());
    final result = await addGoal(AddGoalParams(goal: event.goal));
    emit(result.fold(
      (failure) => PersonaError(message: failure.message),
      (goal) => GoalAdded(goal),
    ));
  }

  Future<void> _onUpdateGoal(
    UpdateGoalEvent event,
    Emitter<PersonaState> emit,
  ) async {
    emit(PersonaLoading());
    final result = await updateGoal(UpdateGoalParams(goal: event.goal));
    emit(result.fold(
      (failure) => PersonaError(message: failure.message),
      (goal) => GoalUpdated(goal),
    ));
  }

  Future<void> _onDeleteGoal(
    DeleteGoalEvent event,
    Emitter<PersonaState> emit,
  ) async {
    emit(PersonaLoading());
    final result = await deleteGoal(DeleteGoalParams(goalId: event.goalId));
    emit(result.fold(
      (failure) => PersonaError(message: failure.message),
      (success) => GoalDeleted(event.goalId),
    ));
  }

  Future<void> _onUpdatePersonality(
    UpdatePersonalityEvent event,
    Emitter<PersonaState> emit,
  ) async {
    emit(PersonaLoading());
    final result = await updatePersonality(UpdatePersonalityParams(personality: event.personality));
    emit(result.fold(
      (failure) => PersonaError(message: failure.message),
      (personality) => PersonalityUpdated(personality),
    ));
  }

  Future<void> _onUpdateInteractionPreference(
    UpdateInteractionPreferenceEvent event,
    Emitter<PersonaState> emit,
  ) async {
    emit(PersonaLoading());
    final result = await updateInteractionPreference(UpdateInteractionPreferenceParams(preference: event.preference));
    emit(result.fold(
      (failure) => PersonaError(message: failure.message),
      (preference) => InteractionPreferenceUpdated(preference),
    ));
  }

  Future<void> _onUpdateMotivationFactors(
    UpdateMotivationFactorsEvent event,
    Emitter<PersonaState> emit,
  ) async {
    emit(PersonaLoading());
    final result = await updateMotivationFactors(UpdateMotivationFactorsParams(factors: event.factors));
    emit(result.fold(
      (failure) => PersonaError(message: failure.message),
      (factors) => MotivationFactorsUpdated(factors),
    ));
  }

  Future<void> _onGenerateInsights(
    GenerateInsightsEvent event,
    Emitter<PersonaState> emit,
  ) async {
    emit(PersonaLoading());
    final result = await generateInsights(NoParams());
    emit(result.fold(
      (failure) => PersonaError(message: failure.message),
      (insights) => InsightsGenerated(insights),
    ));
  }

  Future<void> _onAnalyzeWithAIAdvisor(
    AnalyzeWithAIAdvisorEvent event,
    Emitter<PersonaState> emit,
  ) async {
    emit(PersonaLoading());
    final result = await analyzeWithAIAdvisor(AnalyzeWithAIAdvisorParams(input: event.input));
    emit(result.fold(
      (failure) => PersonaError(message: failure.message),
      (analysis) => AIAdvisorAnalysisLoaded(analysis),
    ));
  }
}
