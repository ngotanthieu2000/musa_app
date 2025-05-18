import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/persona_repository.dart';
import '../entities/ai_advisor_analysis.dart';

/// Parameters for analyzing with AI advisor
class AnalyzeWithAIAdvisorParams {
  final String input;

  AnalyzeWithAIAdvisorParams({required this.input});
}

/// Use case to analyze user input with AI advisors
class AnalyzeWithAIAdvisor implements UseCase<AIAdvisorAnalysis, AnalyzeWithAIAdvisorParams> {
  final PersonaRepository repository;

  AnalyzeWithAIAdvisor(this.repository);

  @override
  Future<Either<Failure, AIAdvisorAnalysis>> call(AnalyzeWithAIAdvisorParams params) async {
    return await repository.analyzeWithAIAdvisor(params.input);
  }
}
