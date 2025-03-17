import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> getTask(String id);
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<List<TaskModel>> getTasksByCategory(String category);
  Future<List<TaskModel>> getTasksByPriority(String priority);
  Future<List<TaskModel>> getTasksByDate(DateTime date);
  Future<void> toggleTaskCompletion(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  TaskRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = 'http://your-api-url/api/tasks',
  });

  @override
  Future<List<TaskModel>> getTasks() async {
    final response = await client.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  @override
  Future<TaskModel> getTask(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return TaskModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load task');
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );
    if (response.statusCode == 201) {
      return TaskModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await client.put(
      Uri.parse('$baseUrl/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );
    if (response.statusCode == 200) {
      return TaskModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update task');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    final response = await client.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete task');
    }
  }

  @override
  Future<List<TaskModel>> getTasksByCategory(String category) async {
    final response = await client.get(Uri.parse('$baseUrl?category=$category'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks by category');
    }
  }

  @override
  Future<List<TaskModel>> getTasksByPriority(String priority) async {
    final response = await client.get(Uri.parse('$baseUrl?priority=$priority'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks by priority');
    }
  }

  @override
  Future<List<TaskModel>> getTasksByDate(DateTime date) async {
    final response = await client.get(
      Uri.parse('$baseUrl?date=${date.toIso8601String()}'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks by date');
    }
  }

  @override
  Future<void> toggleTaskCompletion(String id) async {
    final response = await client.patch(Uri.parse('$baseUrl/$id/toggle'));
    if (response.statusCode != 200) {
      throw Exception('Failed to toggle task completion');
    }
  }
} 