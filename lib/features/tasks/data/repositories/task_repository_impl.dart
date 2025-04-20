import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/error/failures.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    try {
      final taskModels = await remoteDataSource.getTasks();
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get tasks: $e'));
    }
  }

  @override
  Future<Either<Failure, Task>> getTask(String id) async {
    try {
      final taskModel = await remoteDataSource.getTask(id);
      return Right(taskModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get task: $e'));
    }
  }

  @override
  Future<Either<Failure, Task>> createTask({
    required String title,
    required String description,
  }) async {
    try {
      final taskModel = await remoteDataSource.createTask(title, description);
      return Right(taskModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to create task: $e'));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final updatedTaskModel = await remoteDataSource.updateTask(taskModel);
      return Right(updatedTaskModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update task: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    try {
      await remoteDataSource.deleteTask(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete task: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleTaskCompletion(String id) async {
    try {
      await remoteDataSource.toggleTaskCompletion(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to toggle task completion: $e'));
    }
  }
} 