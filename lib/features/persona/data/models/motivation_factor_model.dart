import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/motivation_factor.dart';

part 'motivation_factor_model.g.dart';

@JsonSerializable()
class MotivationFactorModel extends MotivationFactor {
  const MotivationFactorModel({
    required String factor,
    required int importance,
    required String notes,
    required DateTime updatedAt,
  }) : super(
          factor: factor,
          importance: importance,
          notes: notes,
          updatedAt: updatedAt,
        );

  factory MotivationFactorModel.fromJson(Map<String, dynamic> json) => _$MotivationFactorModelFromJson(json);

  Map<String, dynamic> toJson() => _$MotivationFactorModelToJson(this);

  factory MotivationFactorModel.fromEntity(MotivationFactor entity) {
    return MotivationFactorModel(
      factor: entity.factor,
      importance: entity.importance,
      notes: entity.notes,
      updatedAt: entity.updatedAt,
    );
  }
}
