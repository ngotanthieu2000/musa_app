import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/error/failures.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<Task>>> getTasks();
  Future<Either<Failure, Task>> getTask(String id);
  Future<Either<Failure, Task>> createTask({
    required String title,
    required String description,
    DateTime? dueDate,
    TaskPriority? priority,
    String? category,
    List<String>? tags,
    List<Map<String, dynamic>>? subTasks,
    List<Map<String, dynamic>>? reminders,
  });
  Future<Either<Failure, Task>> updateTask(String id, {
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    TaskPriority? priority,
    String? category,
    List<String>? tags,
  });
  Future<Either<Failure, void>> deleteTask(String id);
  Future<Either<Failure, void>> toggleTaskCompletion(String id);
  Future<Either<Failure, SubTask>> addSubTask(String taskId, {
    required String title,
    DateTime? dueDate,
  });
  Future<Either<Failure, void>> updateSubTask(String taskId, String subTaskId, {
    String? title,
    bool? isCompleted,
    DateTime? dueDate,
  });
  Future<Either<Failure, Reminder>> addReminder(String taskId, {
    required String message,
    required DateTime time,
    String type = 'push',
  });
}