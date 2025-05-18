import 'package:equatable/equatable.dart';

/// Represents an opinion from a specific advisor
class AdvisorOpinion extends Equatable {
  /// The role of the advisor (e.g., Psychology, Finance, Career)
  final String role;
  
  /// The opinion of the advisor
  final String opinion;

  const AdvisorOpinion({
    required this.role,
    required this.opinion,
  });

  @override
  List<Object?> get props => [role, opinion];
}

/// Represents an analysis from AI advisors
class AIAdvisorAnalysis extends Equatable {
  /// A summary of the analysis
  final String summary;
  
  /// The opinions from different advisors
  final List<AdvisorOpinion> advisors;
  
  /// The conclusion of the analysis
  final String conclusion;
  
  /// The AI provider used for the analysis
  final String provider;
  
  /// The language of the analysis
  final String language;

  const AIAdvisorAnalysis({
    required this.summary,
    required this.advisors,
    required this.conclusion,
    required this.provider,
    required this.language,
  });

  @override
  List<Object?> get props => [summary, advisors, conclusion, provider, language];
}
