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
      final tasks = await remoteDataSource.getTasks();
      return tasks;
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }

  @override
  Future<Task> getTask(String id) async {
    try {
      final task = await remoteDataSource.getTask(id);
      return task;
    } catch (e) {
      throw Exception('Failed to get task: $e');
    }
  }

  @override
  Future<Task> createTask(Task task) async {
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
      return await remoteDataSource.createTask(taskModel);
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
  Future<List<Task>> getTasksByCategory(String category) async {
    try {
      final tasks = await remoteDataSource.getTasksByCategory(category);
      return tasks;
    } catch (e) {
      throw Exception('Failed to get tasks by category: $e');
    }
  }

  @override
  Future<List<Task>> getTasksByPriority(String priority) async {
    try {
      final tasks = await remoteDataSource.getTasksByPriority(priority);
      return tasks;
    } catch (e) {
      throw Exception('Failed to get tasks by priority: $e');
    }
  }

  @override
  Future<List<Task>> getTasksByDate(DateTime date) async {
    try {
      final tasks = await remoteDataSource.getTasksByDate(date);
      return tasks;
    } catch (e) {
      throw Exception('Failed to get tasks by date: $e');
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