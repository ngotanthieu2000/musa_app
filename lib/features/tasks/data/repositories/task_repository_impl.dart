import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Task>> getTasks() async {
    try {
      return await remoteDataSource.getTasks();
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }

  @override
  Future<Task> getTask(String id) async {
    try {
      return await remoteDataSource.getTask(id);
    } catch (e) {
      throw Exception('Failed to get task: $e');
    }
  }

  @override
  Future<Task> createTask({
    required String title,
    required String description,
  }) async {
    try {
      return await remoteDataSource.createTask(title, description);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  @override
  Future<Task> updateTask(Task task) async {
    try {
      final taskModel = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        isCompleted: task.isCompleted,
        priority: task.priority,
        category: task.category,
        createdAt: task.createdAt,
      );
      return await remoteDataSource.updateTask(taskModel);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await remoteDataSource.deleteTask(id);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  @override
  Future<void> toggleTaskCompletion(String id) async {
    try {
      await remoteDataSource.toggleTaskCompletion(id);
    } catch (e) {
      throw Exception('Failed to toggle task completion: $e');
    }
  }
} 