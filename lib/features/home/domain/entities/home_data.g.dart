// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HomeDataImpl _$$HomeDataImplFromJson(Map<String, dynamic> json) =>
    _$HomeDataImpl(
      userName: json['userName'] as String,
      todayTasks: (json['todayTasks'] as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
      goals: (json['goals'] as List<dynamic>)
          .map((e) => Goal.fromJson(e as Map<String, dynamic>))
          .toList(),
      overallProgress: (json['overallProgress'] as num).toInt(),
      tasksCompleted: (json['tasksCompleted'] as num).toInt(),
      totalTasks: (json['totalTasks'] as num).toInt(),
      reminder: json['reminder'] as String?,
      healthData: json['healthData'] as Map<String, dynamic>?,
      financeData: json['financeData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$HomeDataImplToJson(_$HomeDataImpl instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'todayTasks': instance.todayTasks,
      'goals': instance.goals,
      'overallProgress': instance.overallProgress,
      'tasksCompleted': instance.tasksCompleted,
      'totalTasks': instance.totalTasks,
      'reminder': instance.reminder,
      'healthData': instance.healthData,
      'financeData': instance.financeData,
    };
