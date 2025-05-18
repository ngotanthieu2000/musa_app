import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/emotional_state.dart';

part 'emotional_state_model.g.dart';

@JsonSerializable()
class EmotionalStateModel extends EmotionalState {
  const EmotionalStateModel({
    required String mood,
    required int stressLevel,
    required int energy,
    required DateTime timestamp,
  }) : super(
          mood: mood,
          stressLevel: stressLevel,
          energy: energy,
          timestamp: timestamp,
        );

  factory EmotionalStateModel.fromJson(Map<String, dynamic> json) => _$EmotionalStateModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmotionalStateModelToJson(this);

  factory EmotionalStateModel.fromEntity(EmotionalState entity) {
    return EmotionalStateModel(
      mood: entity.mood,
      stressLevel: entity.stressLevel,
      energy: entity.energy,
      timestamp: entity.timestamp,
    );
  }
}
