import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/persona.dart';
import '../entities/emotional_state.dart';
import '../entities/goal.dart';
import '../entities/personality.dart';
import '../entities/interaction_preference.dart';
import '../entities/motivation_factor.dart';
import '../entities/ai_advisor_analysis.dart';

/// Repository interface for persona-related operations
abstract class PersonaRepository {
  /// Get the persona for the current user
  Future<Either<Failure, Persona>> getPersona();
  
  /// Update the persona for the current user
  Future<Either<Failure, Persona>> updatePersona(Persona persona);
  
  /// Record a new emotional state for the current user
  Future<Either<Failure, EmotionalState>> recordEmotionalState(EmotionalState state);
  
  /// Add a new goal for the current user
  Future<Either<Failure, Goal>> addGoal(Goal goal);
  
  /// Update an existing goal for the current user
  Future<Either<Failure, Goal>> updateGoal(Goal goal);
  
  /// Delete a goal for the current user
  Future<Either<Failure, bool>> deleteGoal(String goalId);
  
  /// Update the personality assessment for the current user
  Future<Either<Failure, Personality>> updatePersonality(Personality personality);
  
  /// Update the interaction preferences for the current user
  Future<Either<Failure, InteractionPreference>> updateInteractionPreference(InteractionPreference preference);
  
  /// Update the motivation factors for the current user
  Future<Either<Failure, List<MotivationFactor>>> updateMotivationFactors(List<MotivationFactor> factors);
  
  /// Generate insights for the current user
  Future<Either<Failure, List<String>>> generateInsights();
  
  /// Analyze user input with AI advisors
  Future<Either<Failure, AIAdvisorAnalysis>> analyzeWithAIAdvisor(String input);
}
