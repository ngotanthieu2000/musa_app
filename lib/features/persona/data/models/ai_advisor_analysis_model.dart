import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/ai_advisor_analysis.dart';

part 'ai_advisor_analysis_model.g.dart';

@JsonSerializable()
class AdvisorOpinionModel extends AdvisorOpinion {
  const AdvisorOpinionModel({
    required String role,
    required String opinion,
  }) : super(
          role: role,
          opinion: opinion,
        );

  factory AdvisorOpinionModel.fromJson(Map<String, dynamic> json) => _$AdvisorOpinionModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdvisorOpinionModelToJson(this);

  factory AdvisorOpinionModel.fromEntity(AdvisorOpinion entity) {
    return AdvisorOpinionModel(
      role: entity.role,
      opinion: entity.opinion,
    );
  }
}

@JsonSerializable()
class AIAdvisorAnalysisModel extends AIAdvisorAnalysis {
  const AIAdvisorAnalysisModel({
    required String summary,
    required List<AdvisorOpinionModel> advisors,
    required String conclusion,
    required String provider,
    required String language,
  }) : super(
          summary: summary,
          advisors: advisors,
          conclusion: conclusion,
          provider: provider,
          language: language,
        );

  factory AIAdvisorAnalysisModel.fromJson(Map<String, dynamic> json) => _$AIAdvisorAnalysisModelFromJson(json);

  Map<String, dynamic> toJson() => _$AIAdvisorAnalysisModelToJson(this);

  factory AIAdvisorAnalysisModel.fromEntity(AIAdvisorAnalysis entity) {
    return AIAdvisorAnalysisModel(
      summary: entity.summary,
      advisors: entity.advisors.map((e) => AdvisorOpinionModel.fromEntity(e)).toList(),
      conclusion: entity.conclusion,
      provider: entity.provider,
      language: entity.language,
    );
  }
}
