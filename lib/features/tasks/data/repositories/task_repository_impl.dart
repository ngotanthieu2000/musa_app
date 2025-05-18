import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/error/failures.dart';
import '../../../../core/error/api_error_type.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    try {
      final taskModels = await remoteDataSource.getTasks();
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get tasks: $e',
        errorType: ApiErrorType.server,
      ));
    }
  }

  @override
  Future<Either<Failure, Task>> getTask(String id) async {
    try {
      final taskModel = await remoteDataSource.getTask(id);
      return Right(taskModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get task: $e',
        errorType: ApiErrorType.server,
      ));
    }
  }

  @override
  Future<Either<Failure, Task>> createTask({
    required String title,
    required String description,
    DateTime? dueDate,
    TaskPriority? priority,
    String? category,
    List<String>? tags,
    List<Map<String, dynamic>>? subTasks,
    List<Map<String, dynamic>>? reminders,
  }) async {
    print('*** TaskRepositoryImpl.createTask: Called ***');
    print('Title: $title');
    print('Description: $description');
    print('Due Date: $dueDate');
    print('Priority: $priority');
    print('Category: $category');
    print('Tags: $tags');

    try {
      final taskData = <String, dynamic>{
        'title': title,
        'description': description,
      };

      if (dueDate != null) {
        taskData['due_date'] = dueDate.toIso8601String();
      }

      if (priority != null) {
        taskData['priority'] = priority.toString().split('.').last;
      }

      if (category != null) {
        taskData['category'] = category;
      }

      if (tags != null) {
        taskData['tags'] = tags;
      }

      if (subTasks != null) {
        taskData['sub_tasks'] = subTasks;
      }

      if (reminders != null) {
        taskData['reminders'] = reminders;
      }

      print('*** TaskRepositoryImpl.createTask: Task data prepared ***');
      print('Task data: $taskData');

      print('*** TaskRepositoryImpl.createTask: Calling remoteDataSource.createTask ***');
      final taskModel = await remoteDataSource.createTask(taskData);
      print('*** TaskRepositoryImpl.createTask: remoteDataSource.createTask returned ***');
      print('Task model: $taskModel');

      return Right(taskModel.toEntity());
    } catch (e) {
      print('*** TaskRepositoryImpl.createTask: Error: $e ***');
      return Left(ServerFailure(
        message: 'Failed to create task: $e',
        errorType: ApiErrorType.server,
      ));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(String id, {
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    TaskPriority? priority,
    String? category,
    List<String>? tags,
  }) async {
    try {
      final taskData = <String, dynamic>{};

      if (title != null) {
        taskData['title'] = title;
      }

      if (description != null) {
        taskData['description'] = description;
      }

      if (isCompleted != null) {
        taskData['is_completed'] = isCompleted;
      }

      if (dueDate != null) {
        taskData['due_date'] = dueDate.toIso8601String();
      }

      if (priority != null) {
        taskData['priority'] = priority.toString().split('.').last;
      }

      if (category != null) {
        taskData['category'] = category;
      }

      if (tags != null) {
        taskData['tags'] = tags;
      }

      final updatedTaskModel = await remoteDataSource.updateTask(id, taskData);
      return Right(updatedTaskModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to update task: $e',
        errorType: ApiErrorType.server,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    try {
      await remoteDataSource.deleteTask(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to delete task: $e',
        errorType: ApiErrorType.server,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> toggleTaskCompletion(String id) async {
    try {
      await remoteDataSource.toggleTaskCompletion(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to toggle task completion: $e',
        errorType: ApiErrorType.server,
      ));
    }
  }

  @override
  Future<Either<Failure, SubTask>> addSubTask(String taskId, {
    required String title,
    DateTime? dueDate,
  }) async {
    try {
      final subTaskData = <String, dynamic>{
        'title': title,
      };

      if (dueDate != null) {
        subTaskData['due_date'] = dueDate.toIso8601String();
      }

      final subTaskModel = await remoteDataSource.addSubTask(taskId, subTaskData);
      return Right(subTaskModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to add subtask: $e',
        errorType: ApiErrorType.server,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> updateSubTask(String taskId, String subTaskId, {
    String? title,
    bool? isCompleted,
    DateTime? dueDate,
  }) async {
    try {
      final subTaskData = <String, dynamic>{};

      if (title != null) {
        subTaskData['title'] = title;
      }

      if (isCompleted != null) {
        subTaskData['is_completed'] = isCompleted;
      }

      if (dueDate != null) {
        subTaskData['due_date'] = dueDate.toIso8601String();
      }

      await remoteDataSource.updateSubTask(taskId, subTaskId, subTaskData);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to update subtask: $e',
        errorType: ApiErrorType.server,
      ));
    }
  }

  @override
  Future<Either<Failure, Reminder>> addReminder(String taskId, {
    required String message,
    required DateTime time,
    String type = 'push',
  }) async {
    try {
      final reminderData = <String, dynamic>{
        'message': message,
        'time': time.toIso8601String(),
        'type': type,
      };

      final reminderModel = await remoteDataSource.addReminder(taskId, reminderData);
      return Right(reminderModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to add reminder: $e',
        errorType: ApiErrorType.server,
      ));
    }
  }
}