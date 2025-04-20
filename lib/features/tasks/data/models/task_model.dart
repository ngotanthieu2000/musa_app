import '../../domain/entities/task.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final TaskStatus? status;
  final TaskPriority? priority;
  final String? category;
  final List<String>? tags;
  final DateTime? completedAt;
  final DateTime? dueDate;
  final bool isRepeating;
  final String? repeatFrequency;
  final String? assignedTo;
  
  TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    this.completed = false,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.priority,
    this.category,
    this.tags,
    this.completedAt,
    this.dueDate,
    this.isRepeating = false,
    this.repeatFrequency,
    this.assignedTo,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'].toString(),
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
      createdAt: json['createdAt'] != null 
        ? DateTime.parse(json['createdAt'] as String) 
        : null,
      updatedAt: json['updatedAt'] != null 
        ? DateTime.parse(json['updatedAt'] as String) 
        : null,
      status: json['status'] != null 
        ? _parseStatus(json['status'])
        : null,
      priority: json['priority'] != null 
        ? _parsePriority(json['priority'])
        : null,
      category: json['category'] as String?,
      tags: json['tags'] != null 
        ? (json['tags'] as List<dynamic>).map((e) => e as String).toList() 
        : null,
      completedAt: json['completedAt'] != null 
        ? DateTime.parse(json['completedAt'] as String) 
        : null,
      dueDate: json['dueDate'] != null 
        ? DateTime.parse(json['dueDate'] as String) 
        : null,
      isRepeating: json['isRepeating'] as bool? ?? false,
      repeatFrequency: json['repeatFrequency'] as String?,
      assignedTo: json['assignedTo'] as String?,
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
  
  static String _statusToString(TaskStatus? status) {
    if (status == null) return 'pending';
    
    switch (status) {
      case TaskStatus.pending: return 'pending';
      case TaskStatus.inProgress: return 'in_progress';
      case TaskStatus.completed: return 'completed';
      case TaskStatus.cancelled: return 'cancelled';
    }
  }
  
  static String _priorityToString(TaskPriority? priority) {
    if (priority == null) return 'medium';
    
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
      'completed': completed,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'status': status != null ? _statusToString(status) : null,
      'priority': priority != null ? _priorityToString(priority) : null,
      'category': category,
      'tags': tags,
      'completedAt': completedAt?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'isRepeating': isRepeating,
      'repeatFrequency': repeatFrequency,
      'assignedTo': assignedTo,
    };
  }
  
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      completed: completed,
      createdAt: createdAt,
      updatedAt: updatedAt,
      status: status,
      priority: priority,
      category: category,
      tags: tags,
      completedAt: completedAt,
      dueDate: dueDate,
      isRepeating: isRepeating,
      repeatFrequency: repeatFrequency,
      assignedTo: assignedTo,
    );
  }
  
  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      completed: task.completed,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      status: task.status,
      priority: task.priority,
      category: task.category,
      tags: task.tags,
      completedAt: task.completedAt,
      dueDate: task.dueDate,
      isRepeating: task.isRepeating,
      repeatFrequency: task.repeatFrequency,
      assignedTo: task.assignedTo,
    );
  }
} 