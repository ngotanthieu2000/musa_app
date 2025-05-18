// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motivation_factor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MotivationFactorModel _$MotivationFactorModelFromJson(
        Map<String, dynamic> json) =>
    MotivationFactorModel(
      factor: json['factor'] as String,
      importance: (json['importance'] as num).toInt(),
      notes: json['notes'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MotivationFactorModelToJson(
        MotivationFactorModel instance) =>
    <String, dynamic>{
      'factor': instance.factor,
      'importance': instance.importance,
      'notes': instance.notes,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
