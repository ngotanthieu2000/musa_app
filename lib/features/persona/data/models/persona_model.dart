import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/persona.dart';
import 'emotional_state_model.dart';
import 'goal_model.dart';
import 'personality_model.dart';
import 'interaction_preference_model.dart';
import 'motivation_factor_model.dart';
import 'behavior_metrics_model.dart';

part 'persona_model.g.dart';

@JsonSerializable()
class PersonaModel extends Persona {
  const PersonaModel({
    required String id,
    required String userId,
    required Map<String, dynamic> basicInfo,
    required PersonalityModel personality,
    required List<EmotionalStateModel> emotionalStates,
    required EmotionalStateModel currentEmotionalState,
    required List<GoalModel> goals,
    required BehaviorMetricsModel behaviorMetrics,
    required List<MotivationFactorModel> motivationFactors,
    required InteractionPreferenceModel interactionPreference,
    required List<String> insights,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) : super(
          id: id,
          userId: userId,
          basicInfo: basicInfo,
          personality: personality,
          emotionalStates: emotionalStates,
          currentEmotionalState: currentEmotionalState,
          goals: goals,
          behaviorMetrics: behaviorMetrics,
          motivationFactors: motivationFactors,
          interactionPreference: interactionPreference,
          insights: insights,
          createdAt: createdAt,
          updatedAt: updatedAt,
          version: version,
        );

  factory PersonaModel.fromJson(Map<String, dynamic> json) => _$PersonaModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonaModelToJson(this);

  factory PersonaModel.fromEntity(Persona persona) {
    return PersonaModel(
      id: persona.id,
      userId: persona.userId,
      basicInfo: persona.basicInfo,
      personality: PersonalityModel.fromEntity(persona.personality),
      emotionalStates: persona.emotionalStates
          .map((e) => EmotionalStateModel.fromEntity(e))
          .toList(),
      currentEmotionalState: EmotionalStateModel.fromEntity(persona.currentEmotionalState),
      goals: persona.goals.map((e) => GoalModel.fromEntity(e)).toList(),
      behaviorMetrics: BehaviorMetricsModel.fromEntity(persona.behaviorMetrics),
      motivationFactors: persona.motivationFactors
          .map((e) => MotivationFactorModel.fromEntity(e))
          .toList(),
      interactionPreference: InteractionPreferenceModel.fromEntity(persona.interactionPreference),
      insights: persona.insights,
      createdAt: persona.createdAt,
      updatedAt: persona.updatedAt,
      version: persona.version,
    );
  }
}
