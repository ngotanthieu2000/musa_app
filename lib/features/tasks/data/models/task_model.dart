import '../../domain/entities/task.dart';

class SubTaskModel {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime? dueDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SubTaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
  });

  factory SubTaskModel.fromJson(Map<String, dynamic> json) {
    print('SubTaskModel.fromJson keys: ${json.keys.toList()}');

    final id = json['id'] ?? json['_id'] ?? '';
    final title = json['title'] ?? '';
    final isCompleted = json['is_completed'] ?? json['isCompleted'] ?? json['completed'] ?? false;

    DateTime? dueDate;
    if (json['due_date'] != null) {
      dueDate = DateTime.parse(json['due_date']);
    } else if (json['dueDate'] != null) {
      dueDate = DateTime.parse(json['dueDate']);
    }

    DateTime? createdAt;
    if (json['created_at'] != null) {
      createdAt = DateTime.parse(json['created_at']);
    } else if (json['createdAt'] != null) {
      createdAt = DateTime.parse(json['createdAt']);
    }

    DateTime? updatedAt;
    if (json['updated_at'] != null) {
      updatedAt = DateTime.parse(json['updated_at']);
    } else if (json['updatedAt'] != null) {
      updatedAt = DateTime.parse(json['updatedAt']);
    }

    return SubTaskModel(
      id: id,
      title: title,
      isCompleted: isCompleted,
      dueDate: dueDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
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

  SubTask toEntity() {
    return SubTask(
      id: id,
      title: title,
      isCompleted: isCompleted,
      dueDate: dueDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory SubTaskModel.fromEntity(SubTask subTask) {
    return SubTaskModel(
      id: subTask.id,
      title: subTask.title,
      isCompleted: subTask.isCompleted,
      dueDate: subTask.dueDate,
      createdAt: subTask.createdAt,
      updatedAt: subTask.updatedAt,
    );
  }
}

class ReminderModel {
  final String id;
  final String type;
  final String message;
  final DateTime time;
  final bool isSent;

  ReminderModel({
    required this.id,
    required this.type,
    required this.message,
    required this.time,
    this.isSent = false,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    print('ReminderModel.fromJson keys: ${json.keys.toList()}');

    final id = json['id'] ?? json['_id'] ?? '';
    final type = json['type'] ?? 'push';
    final message = json['message'] ?? json['content'] ?? '';

    DateTime time;
    if (json['time'] != null) {
      time = DateTime.parse(json['time']);
    } else if (json['reminderTime'] != null) {
      time = DateTime.parse(json['reminderTime']);
    } else if (json['date'] != null) {
      time = DateTime.parse(json['date']);
    } else {
      time = DateTime.now().add(const Duration(days: 1));
    }

    final isSent = json['is_sent'] ?? json['isSent'] ?? false;

    return ReminderModel(
      id: id,
      type: type,
      message: message,
      time: time,
      isSent: isSent,
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

  Reminder toEntity() {
    return Reminder(
      id: id,
      type: type,
      message: message,
      time: time,
      isSent: isSent,
    );
  }

  factory ReminderModel.fromEntity(Reminder reminder) {
    return ReminderModel(
      id: reminder.id,
      type: reminder.type,
      message: reminder.message,
      time: reminder.time,
      isSent: reminder.isSent,
    );
  }
}

class TaskModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime? dueDate;
  final TaskPriority priority;
  final String category;
  final List<String> tags;
  final List<SubTaskModel> subTasks;
  final List<ReminderModel> reminders;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int progress;

  TaskModel({
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

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    // Print the keys to debug
    print('TaskModel.fromJson keys: ${json.keys.toList()}');

    // Handle different field naming conventions
    final id = json['id'] ?? json['_id'] ?? '';
    final userId = json['user_id'] ?? json['userId'] ?? '';
    final title = json['title'] ?? '';
    final description = json['description'] ?? '';
    final isCompleted = json['is_completed'] ?? json['isCompleted'] ?? json['completed'] ?? false;

    // Handle different date formats
    DateTime? dueDate;
    if (json['due_date'] != null) {
      dueDate = DateTime.parse(json['due_date']);
    } else if (json['dueDate'] != null) {
      dueDate = DateTime.parse(json['dueDate']);
    }

    // Handle priority
    final priority = _parsePriority(json['priority']);

    // Handle category
    final category = json['category'] ?? '';

    // Handle tags
    List<String> tags = [];
    if (json['tags'] != null) {
      if (json['tags'] is List) {
        tags = List<String>.from(json['tags']);
      } else if (json['tags'] is String) {
        // Handle case where tags might be a comma-separated string
        tags = (json['tags'] as String).split(',').map((e) => e.trim()).toList();
      }
    }

    // Handle subtasks
    List<SubTaskModel> subTasks = [];
    if (json['sub_tasks'] != null) {
      subTasks = List<SubTaskModel>.from(
          json['sub_tasks'].map((x) => SubTaskModel.fromJson(x)));
    } else if (json['subTasks'] != null) {
      subTasks = List<SubTaskModel>.from(
          json['subTasks'].map((x) => SubTaskModel.fromJson(x)));
    }

    // Handle reminders
    List<ReminderModel> reminders = [];
    if (json['reminders'] != null) {
      reminders = List<ReminderModel>.from(
          json['reminders'].map((x) => ReminderModel.fromJson(x)));
    }

    // Handle dates
    DateTime createdAt;
    if (json['created_at'] != null) {
      createdAt = DateTime.parse(json['created_at']);
    } else if (json['createdAt'] != null) {
      createdAt = DateTime.parse(json['createdAt']);
    } else {
      createdAt = DateTime.now();
    }

    DateTime updatedAt;
    if (json['updated_at'] != null) {
      updatedAt = DateTime.parse(json['updated_at']);
    } else if (json['updatedAt'] != null) {
      updatedAt = DateTime.parse(json['updatedAt']);
    } else {
      updatedAt = DateTime.now();
    }

    // Handle progress
    final progress = json['progress'] ?? 0;

    return TaskModel(
      id: id,
      userId: userId,
      title: title,
      description: description,
      isCompleted: isCompleted,
      dueDate: dueDate,
      priority: priority,
      category: category,
      tags: tags,
      subTasks: subTasks,
      reminders: reminders,
      createdAt: createdAt,
      updatedAt: updatedAt,
      progress: progress,
    );
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

  Task toEntity() {
    return Task(
      id: id,
      userId: userId,
      title: title,
      description: description,
      isCompleted: isCompleted,
      dueDate: dueDate,
      priority: priority,
      category: category,
      tags: tags,
      subTasks: subTasks.map((x) => x.toEntity()).toList(),
      reminders: reminders.map((x) => x.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      progress: progress,
    );
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      userId: task.userId,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      dueDate: task.dueDate,
      priority: task.priority,
      category: task.category,
      tags: task.tags,
      subTasks: task.subTasks.map((x) => SubTaskModel.fromEntity(x)).toList(),
      reminders: task.reminders.map((x) => ReminderModel.fromEntity(x)).toList(),
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      progress: task.progress,
    );
  }
}