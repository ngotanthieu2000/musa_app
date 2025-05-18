import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/persona.dart';
import '../../domain/entities/emotional_state.dart';
import '../../domain/entities/goal.dart';
import '../../domain/entities/personality.dart';
import '../../domain/entities/interaction_preference.dart';
import '../../domain/entities/motivation_factor.dart';
import '../../domain/entities/ai_advisor_analysis.dart';
import '../../domain/repositories/persona_repository.dart';
import '../datasources/persona_remote_data_source.dart';
import '../models/emotional_state_model.dart';
import '../models/goal_model.dart';
import '../models/persona_model.dart';
import '../models/personality_model.dart';
import '../models/interaction_preference_model.dart';
import '../models/motivation_factor_model.dart';

class PersonaRepositoryImpl implements PersonaRepository {
  final PersonaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PersonaRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Persona>> getPersona() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePersona = await remoteDataSource.getPersona();
        return Right(remotePersona);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Persona>> updatePersona(Persona persona) async {
    if (await networkInfo.isConnected) {
      try {
        final personaModel = PersonaModel.fromEntity(persona);
        final updatedPersona = await remoteDataSource.updatePersona(personaModel);
        return Right(updatedPersona);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, EmotionalState>> recordEmotionalState(EmotionalState state) async {
    if (await networkInfo.isConnected) {
      try {
        final stateModel = EmotionalStateModel.fromEntity(state);
        final recordedState = await remoteDataSource.recordEmotionalState(stateModel);
        return Right(recordedState);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Goal>> addGoal(Goal goal) async {
    if (await networkInfo.isConnected) {
      try {
        final goalModel = GoalModel.fromEntity(goal);
        final addedGoal = await remoteDataSource.addGoal(goalModel);
        return Right(addedGoal);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Goal>> updateGoal(Goal goal) async {
    if (await networkInfo.isConnected) {
      try {
        final goalModel = GoalModel.fromEntity(goal);
        final updatedGoal = await remoteDataSource.updateGoal(goalModel);
        return Right(updatedGoal);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteGoal(String goalId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.deleteGoal(goalId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Personality>> updatePersonality(Personality personality) async {
    if (await networkInfo.isConnected) {
      try {
        final personalityModel = PersonalityModel.fromEntity(personality);
        final updatedPersonality = await remoteDataSource.updatePersonality(personalityModel);
        return Right(updatedPersonality);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, InteractionPreference>> updateInteractionPreference(InteractionPreference preference) async {
    if (await networkInfo.isConnected) {
      try {
        final preferenceModel = InteractionPreferenceModel.fromEntity(preference);
        final updatedPreference = await remoteDataSource.updateInteractionPreference(preferenceModel);
        return Right(updatedPreference);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<MotivationFactor>>> updateMotivationFactors(List<MotivationFactor> factors) async {
    if (await networkInfo.isConnected) {
      try {
        final factorModels = factors.map((e) => MotivationFactorModel.fromEntity(e)).toList();
        final updatedFactors = await remoteDataSource.updateMotivationFactors(factorModels);
        return Right(updatedFactors);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> generateInsights() async {
    if (await networkInfo.isConnected) {
      try {
        final insights = await remoteDataSource.generateInsights();
        return Right(insights);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AIAdvisorAnalysis>> analyzeWithAIAdvisor(String input) async {
    if (await networkInfo.isConnected) {
      try {
        final analysis = await remoteDataSource.analyzeWithAIAdvisor(input);
        return Right(analysis);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
