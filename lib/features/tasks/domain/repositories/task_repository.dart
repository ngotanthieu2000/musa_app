import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/error/failures.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<Task>>> getTasks();
  Future<Either<Failure, Task>> getTask(String id);
  Future<Either<Failure, Task>> createTask({
    required String title,
    required String description,
  });
  Future<Either<Failure, Task>> updateTask(Task task);
  Future<Either<Failure, void>> deleteTask(String id);
  Future<Either<Failure, void>> toggleTaskCompletion(String id);
} 