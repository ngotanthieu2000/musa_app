// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'behavior_metrics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BehaviorMetricsModel _$BehaviorMetricsModelFromJson(
        Map<String, dynamic> json) =>
    BehaviorMetricsModel(
      todoCompletionRate: (json['todoCompletionRate'] as num).toDouble(),
      avgTodoCompletionTime: (json['avgTodoCompletionTime'] as num).toDouble(),
      learningTimePerWeek: (json['learningTimePerWeek'] as num).toDouble(),
      reflectionFrequency: (json['reflectionFrequency'] as num).toDouble(),
      appUsageFrequency: (json['appUsageFrequency'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$BehaviorMetricsModelToJson(
        BehaviorMetricsModel instance) =>
    <String, dynamic>{
      'todoCompletionRate': instance.todoCompletionRate,
      'avgTodoCompletionTime': instance.avgTodoCompletionTime,
      'learningTimePerWeek': instance.learningTimePerWeek,
      'reflectionFrequency': instance.reflectionFrequency,
      'appUsageFrequency': instance.appUsageFrequency,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
