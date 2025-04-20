// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoalImpl _$$GoalImplFromJson(Map<String, dynamic> json) => _$GoalImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      deadline: DateTime.parse(json['deadline'] as String),
      type: $enumDecode(_$GoalTypeEnumMap, json['type']),
      category: $enumDecode(_$GoalCategoryEnumMap, json['category']),
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      targetValue: (json['targetValue'] as num?)?.toInt() ?? 100,
      unit: json['unit'] as String?,
      milestones: (json['milestones'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      relatedTaskIds: (json['relatedTaskIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$GoalImplToJson(_$GoalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'deadline': instance.deadline.toIso8601String(),
      'type': _$GoalTypeEnumMap[instance.type]!,
      'category': _$GoalCategoryEnumMap[instance.category]!,
      'progress': instance.progress,
      'targetValue': instance.targetValue,
      'unit': instance.unit,
      'milestones': instance.milestones,
      'relatedTaskIds': instance.relatedTaskIds,
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$GoalTypeEnumMap = {
  GoalType.daily: 'daily',
  GoalType.weekly: 'weekly',
  GoalType.monthly: 'monthly',
  GoalType.yearly: 'yearly',
  GoalType.custom: 'custom',
};

const _$GoalCategoryEnumMap = {
  GoalCategory.health: 'health',
  GoalCategory.career: 'career',
  GoalCategory.finance: 'finance',
  GoalCategory.personal: 'personal',
  GoalCategory.education: 'education',
  GoalCategory.other: 'other',
};
