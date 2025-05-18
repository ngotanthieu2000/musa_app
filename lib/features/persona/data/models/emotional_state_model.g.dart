// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotional_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmotionalStateModel _$EmotionalStateModelFromJson(Map<String, dynamic> json) =>
    EmotionalStateModel(
      mood: json['mood'] as String,
      stressLevel: (json['stressLevel'] as num).toInt(),
      energy: (json['energy'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$EmotionalStateModelToJson(
        EmotionalStateModel instance) =>
    <String, dynamic>{
      'mood': instance.mood,
      'stressLevel': instance.stressLevel,
      'energy': instance.energy,
      'timestamp': instance.timestamp.toIso8601String(),
    };
