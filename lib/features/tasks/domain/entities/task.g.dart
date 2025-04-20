// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: DateTime.parse(json['dueDate'] as String),
      status: $enumDecode(_$TaskStatusEnumMap, json['status']),
      priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
      category: json['category'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isRepeating: json['isRepeating'] as bool? ?? false,
      repeatFrequency: json['repeatFrequency'] as String?,
      assignedTo: json['assignedTo'] as String?,
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'dueDate': instance.dueDate.toIso8601String(),
      'status': _$TaskStatusEnumMap[instance.status]!,
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'category': instance.category,
      'tags': instance.tags,
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isRepeating': instance.isRepeating,
      'repeatFrequency': instance.repeatFrequency,
      'assignedTo': instance.assignedTo,
    };

const _$TaskStatusEnumMap = {
  TaskStatus.pending: 'pending',
  TaskStatus.inProgress: 'inProgress',
  TaskStatus.completed: 'completed',
  TaskStatus.cancelled: 'cancelled',
};

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'low',
  TaskPriority.medium: 'medium',
  TaskPriority.high: 'high',
};
