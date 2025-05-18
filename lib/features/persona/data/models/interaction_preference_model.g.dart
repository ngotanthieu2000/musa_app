// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interaction_preference_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InteractionPreferenceModel _$InteractionPreferenceModelFromJson(
        Map<String, dynamic> json) =>
    InteractionPreferenceModel(
      communicationStyle: json['communicationStyle'] as String,
      responseLength: json['responseLength'] as String,
      topicPreferences: (json['topicPreferences'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      avoidTopics: (json['avoidTopics'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$InteractionPreferenceModelToJson(
        InteractionPreferenceModel instance) =>
    <String, dynamic>{
      'communicationStyle': instance.communicationStyle,
      'responseLength': instance.responseLength,
      'topicPreferences': instance.topicPreferences,
      'avoidTopics': instance.avoidTopics,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
