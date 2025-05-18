import 'package:equatable/equatable.dart';

enum TaskPriority { low, medium, high, critical }

class SubTask extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime? dueDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SubTask({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        isCompleted,
        dueDate,
        createdAt,
        updatedAt,
      ];

  SubTask copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubTask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      id: json['id'],
      title: json['title'],
      isCompleted: json['is_completed'] ?? false,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'is_completed': isCompleted,
      'due_date': dueDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class Reminder extends Equatable {
  final String id;
  final String type;
  final String message;
  final DateTime time;
  final bool isSent;

  const Reminder({
    required this.id,
    required this.type,
    required this.message,
    required this.time,
    this.isSent = false,
  });

  @override
  List<Object?> get props => [id, type, message, time, isSent];

  Reminder copyWith({
    String? id,
    String? type,
    String? message,
    DateTime? time,
    bool? isSent,
  }) {
    return Reminder(
      id: id ?? this.id,
      type: type ?? this.type,
      message: message ?? this.message,
      time: time ?? this.time,
      isSent: isSent ?? this.isSent,
    );
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      type: json['type'],
      message: json['message'] ?? '',
      time: DateTime.parse(json['time']),
      isSent: json['is_sent'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'message': message,
      'time': time.toIso8601String(),
      'is_sent': isSent,
    };
  }
}

class Task extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime? dueDate;
  final TaskPriority priority;
  final String category;
  final List<String> tags;
  final List<SubTask> subTasks;
  final List<Reminder> reminders;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int progress;

  const Task({
    required this.id,
    required this.userId,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.dueDate,
    this.priority = TaskPriority.medium,
    this.category = '',
    this.tags = const [],
    this.subTasks = const [],
    this.reminders = const [],
    required this.createdAt,
    required this.updatedAt,
    this.progress = 0,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        isCompleted,
        dueDate,
        priority,
        category,
        tags,
        subTasks,
        reminders,
        createdAt,
        updatedAt,
        progress,
      ];

  Task copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    TaskPriority? priority,
    String? category,
    List<String>? tags,
    List<SubTask>? subTasks,
    List<Reminder>? reminders,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? progress,
  }) {
    return Task(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      subTasks: subTasks ?? this.subTasks,
      reminders: reminders ?? this.reminders,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      progress: progress ?? this.progress,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['user_id'] ?? '',
      title: json['title'],
      description: json['description'] ?? '',
      isCompleted: json['is_completed'] ?? false,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      priority: _parsePriority(json['priority']),
      category: json['category'] ?? '',
      tags: json['tags'] != null
          ? List<String>.from(json['tags'])
          : [],
      subTasks: json['sub_tasks'] != null
          ? List<SubTask>.from(json['sub_tasks'].map((x) => SubTask.fromJson(x)))
          : [],
      reminders: json['reminders'] != null
          ? List<Reminder>.from(json['reminders'].map((x) => Reminder.fromJson(x)))
          : [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      progress: json['progress'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'is_completed': isCompleted,
      'due_date': dueDate?.toIso8601String(),
      'priority': priority.toString().split('.').last,
      'category': category,
      'tags': tags,
      'sub_tasks': subTasks.map((x) => x.toJson()).toList(),
      'reminders': reminders.map((x) => x.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'progress': progress,
    };
  }

  bool isOverdue() {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  bool isDueSoon() {
    if (dueDate == null || isCompleted) return false;
    final difference = dueDate!.difference(DateTime.now());
    return difference.inHours <= 24 && difference.inHours > 0;
  }

  static TaskPriority _parsePriority(String? priority) {
    if (priority == null) return TaskPriority.medium;

    switch (priority.toLowerCase()) {
      case 'low':
        return TaskPriority.low;
      case 'medium':
        return TaskPriority.medium;
      case 'high':
        return TaskPriority.high;
      case 'critical':
        return TaskPriority.critical;
      default:
        return TaskPriority.medium;
    }
  }
}