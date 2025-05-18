import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/goal.dart';

part 'goal_model.g.dart';

@JsonSerializable()
class GoalModel extends Goal {
  const GoalModel({
    required String id,
    required String category,
    required String description,
    required String timeframe,
    required int progress,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          category: category,
          description: description,
          timeframe: timeframe,
          progress: progress,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory GoalModel.fromJson(Map<String, dynamic> json) => _$GoalModelFromJson(json);

  Map<String, dynamic> toJson() => _$GoalModelToJson(this);

  factory GoalModel.fromEntity(Goal entity) {
    return GoalModel(
      id: entity.id,
      category: entity.category,
      description: entity.description,
      timeframe: entity.timeframe,
      progress: entity.progress,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
