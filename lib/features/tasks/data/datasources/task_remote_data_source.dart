import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../config/env_config.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> getTask(String id);
  Future<TaskModel> createTask(String title, String description);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<void> toggleTaskCompletion(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  TaskRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = EnvConfig.apiBaseUrl,
  });

  @override
  Future<List<TaskModel>> getTasks() async {
    final response = await client.get(Uri.parse('$baseUrl/api/v1/tasks'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  @override
  Future<TaskModel> getTask(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/api/v1/tasks/$id'));

    if (response.statusCode == 200) {
      return TaskModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load task');
    }
  }

  @override
  Future<TaskModel> createTask(String title, String description) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'description': description,
      }),
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
      Uri.parse('$baseUrl/api/v1/tasks/${task.id}'),
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
    final response = await client.delete(Uri.parse('$baseUrl/api/v1/tasks/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete task');
    }
  }

  @override
  Future<void> toggleTaskCompletion(String id) async {
    final response = await client.patch(Uri.parse('$baseUrl/api/v1/tasks/$id/toggle'));

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle task completion');
    }
  }
} 