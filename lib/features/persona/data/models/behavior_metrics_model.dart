import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/behavior_metrics.dart';

part 'behavior_metrics_model.g.dart';

@JsonSerializable()
class BehaviorMetricsModel extends BehaviorMetrics {
  const BehaviorMetricsModel({
    required double todoCompletionRate,
    required double avgTodoCompletionTime,
    required double learningTimePerWeek,
    required double reflectionFrequency,
    required double appUsageFrequency,
    required DateTime lastUpdated,
  }) : super(
          todoCompletionRate: todoCompletionRate,
          avgTodoCompletionTime: avgTodoCompletionTime,
          learningTimePerWeek: learningTimePerWeek,
          reflectionFrequency: reflectionFrequency,
          appUsageFrequency: appUsageFrequency,
          lastUpdated: lastUpdated,
        );

  factory BehaviorMetricsModel.fromJson(Map<String, dynamic> json) => _$BehaviorMetricsModelFromJson(json);

  Map<String, dynamic> toJson() => _$BehaviorMetricsModelToJson(this);

  factory BehaviorMetricsModel.fromEntity(BehaviorMetrics entity) {
    return BehaviorMetricsModel(
      todoCompletionRate: entity.todoCompletionRate,
      avgTodoCompletionTime: entity.avgTodoCompletionTime,
      learningTimePerWeek: entity.learningTimePerWeek,
      reflectionFrequency: entity.reflectionFrequency,
      appUsageFrequency: entity.appUsageFrequency,
      lastUpdated: entity.lastUpdated,
    );
  }
}
