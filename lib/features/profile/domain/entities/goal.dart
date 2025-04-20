import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal.freezed.dart';
part 'goal.g.dart';

enum GoalType { daily, weekly, monthly, yearly, custom }

enum GoalCategory { health, career, finance, personal, education, other }

@freezed
class Goal with _$Goal {
  const factory Goal({
    required String id,
    required String title,
    String? description,
    required DateTime deadline,
    required GoalType type,
    required GoalCategory category,
    @Default(0) int progress,
    @Default(100) int targetValue,
    String? unit,
    List<String>? milestones,
    List<String>? relatedTaskIds,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
} 