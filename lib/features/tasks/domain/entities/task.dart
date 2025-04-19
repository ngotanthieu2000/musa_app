import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

enum TaskPriority { low, medium, high }

enum TaskStatus { pending, inProgress, completed, cancelled }

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    String? description,
    required DateTime dueDate,
    required TaskStatus status,
    required TaskPriority priority,
    String? category,
    List<String>? tags,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(false) bool isRepeating,
    String? repeatFrequency,
    String? assignedTo,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
} 