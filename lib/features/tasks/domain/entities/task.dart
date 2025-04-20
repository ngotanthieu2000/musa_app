import 'package:equatable/equatable.dart';

enum TaskPriority { low, medium, high }

enum TaskStatus { pending, inProgress, completed, cancelled }

class Task extends Equatable {
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

  const Task({
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

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        completed,
        createdAt,
        updatedAt,
        status,
        priority,
        category,
        tags,
        completedAt,
        dueDate,
        isRepeating,
        repeatFrequency,
        assignedTo,
      ];

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
    TaskStatus? status,
    TaskPriority? priority,
    String? category,
    List<String>? tags,
    DateTime? completedAt,
    DateTime? dueDate,
    bool? isRepeating,
    String? repeatFrequency,
    String? assignedTo,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      completedAt: completedAt ?? this.completedAt,
      dueDate: dueDate ?? this.dueDate,
      isRepeating: isRepeating ?? this.isRepeating,
      repeatFrequency: repeatFrequency ?? this.repeatFrequency,
      assignedTo: assignedTo ?? this.assignedTo,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
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
        ? TaskStatus.values.firstWhere(
            (e) => e.toString() == 'TaskStatus.${json['status']}',
            orElse: () => TaskStatus.pending) 
        : null,
      priority: json['priority'] != null 
        ? TaskPriority.values.firstWhere(
            (e) => e.toString() == 'TaskPriority.${json['priority']}',
            orElse: () => TaskPriority.medium) 
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'status': status?.toString().split('.').last,
      'priority': priority?.toString().split('.').last,
      'category': category,
      'tags': tags,
      'completedAt': completedAt?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'isRepeating': isRepeating,
      'repeatFrequency': repeatFrequency,
      'assignedTo': assignedTo,
    };
  }
} 