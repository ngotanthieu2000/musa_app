import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/interaction_preference.dart';

part 'interaction_preference_model.g.dart';

@JsonSerializable()
class InteractionPreferenceModel extends InteractionPreference {
  const InteractionPreferenceModel({
    required String communicationStyle,
    required String responseLength,
    required List<String> topicPreferences,
    required List<String> avoidTopics,
    required DateTime updatedAt,
  }) : super(
          communicationStyle: communicationStyle,
          responseLength: responseLength,
          topicPreferences: topicPreferences,
          avoidTopics: avoidTopics,
          updatedAt: updatedAt,
        );

  factory InteractionPreferenceModel.fromJson(Map<String, dynamic> json) => _$InteractionPreferenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$InteractionPreferenceModelToJson(this);

  factory InteractionPreferenceModel.fromEntity(InteractionPreference entity) {
    return InteractionPreferenceModel(
      communicationStyle: entity.communicationStyle,
      responseLength: entity.responseLength,
      topicPreferences: entity.topicPreferences,
      avoidTopics: entity.avoidTopics,
      updatedAt: entity.updatedAt,
    );
  }
}
