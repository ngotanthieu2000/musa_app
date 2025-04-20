import '../../domain/entities/task.dart';

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final TaskStatus status;
  final TaskPriority priority;
  final String? category;
  final DateTime? createdAt;
  
  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.status,
    required this.priority,
    this.category,
    this.createdAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      status: _parseStatus(json['status']),
      priority: _parsePriority(json['priority']),
      category: json['category'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
  
  static TaskStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return TaskStatus.pending;
      case 'in_progress': return TaskStatus.inProgress;
      case 'completed': return TaskStatus.completed;
      case 'cancelled': return TaskStatus.cancelled;
      default: return TaskStatus.pending;
    }
  }
  
  static TaskPriority _parsePriority(String priority) {
    switch (priority.toLowerCase()) {
      case 'low': return TaskPriority.low;
      case 'medium': return TaskPriority.medium;
      case 'high': return TaskPriority.high;
      default: return TaskPriority.medium;
    }
  }
  
  static String _statusToString(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending: return 'pending';
      case TaskStatus.inProgress: return 'in_progress';
      case TaskStatus.completed: return 'completed';
      case TaskStatus.cancelled: return 'cancelled';
    }
  }
  
  static String _priorityToString(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low: return 'low';
      case TaskPriority.medium: return 'medium';
      case TaskPriority.high: return 'high';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': _statusToString(status),
      'priority': _priorityToString(priority),
      'category': category,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
  
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      status: status,
      priority: priority,
      category: category,
      createdAt: createdAt,
    );
  }
  
  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      status: task.status,
      priority: task.priority,
      category: task.category,
      createdAt: task.createdAt,
    );
  }
} 