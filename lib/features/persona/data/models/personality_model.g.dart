// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personality_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalityModel _$PersonalityModelFromJson(Map<String, dynamic> json) =>
    PersonalityModel(
      type: json['type'] as String,
      value: json['value'] as String,
      traits:
          (json['traits'] as List<dynamic>).map((e) => e as String).toList(),
      strengths:
          (json['strengths'] as List<dynamic>).map((e) => e as String).toList(),
      weaknesses: (json['weaknesses'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PersonalityModelToJson(PersonalityModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'value': instance.value,
      'traits': instance.traits,
      'strengths': instance.strengths,
      'weaknesses': instance.weaknesses,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
