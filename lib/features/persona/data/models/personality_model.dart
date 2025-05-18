import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/personality.dart';

part 'personality_model.g.dart';

@JsonSerializable()
class PersonalityModel extends Personality {
  const PersonalityModel({
    required String type,
    required String value,
    required List<String> traits,
    required List<String> strengths,
    required List<String> weaknesses,
    required DateTime updatedAt,
  }) : super(
          type: type,
          value: value,
          traits: traits,
          strengths: strengths,
          weaknesses: weaknesses,
          updatedAt: updatedAt,
        );

  factory PersonalityModel.fromJson(Map<String, dynamic> json) => _$PersonalityModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalityModelToJson(this);

  factory PersonalityModel.fromEntity(Personality entity) {
    return PersonalityModel(
      type: entity.type,
      value: entity.value,
      traits: entity.traits,
      strengths: entity.strengths,
      weaknesses: entity.weaknesses,
      updatedAt: entity.updatedAt,
    );
  }
}
