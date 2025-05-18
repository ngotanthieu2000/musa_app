import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../domain/repositories/persona_repository.dart';
import '../domain/usecases/get_persona.dart';
import '../domain/usecases/update_persona.dart';
import '../domain/usecases/record_emotional_state.dart';
import '../domain/usecases/add_goal.dart';
import '../domain/usecases/update_goal.dart';
import '../domain/usecases/delete_goal.dart';
import '../domain/usecases/update_personality.dart';
import '../domain/usecases/update_interaction_preference.dart';
import '../domain/usecases/update_motivation_factors.dart';
import '../domain/usecases/generate_insights.dart';
import '../domain/usecases/analyze_with_ai_advisor.dart';
import '../data/repositories/persona_repository_impl.dart';
import '../data/datasources/persona_remote_data_source.dart';
import '../data/datasources/persona_mock_data_source.dart';
import '../presentation/bloc/persona_bloc.dart';
import '../../../core/network_info.dart';
import '../../../core/services/auth_service.dart';

final sl = GetIt.instance;

Future<void> initPersonaFeature() async {
  // Bloc
  sl.registerFactory(
    () => PersonaBloc(
      getPersona: sl(),
      updatePersona: sl(),
      recordEmotionalState: sl(),
      addGoal: sl(),
      updateGoal: sl(),
      deleteGoal: sl(),
      updatePersonality: sl(),
      updateInteractionPreference: sl(),
      updateMotivationFactors: sl(),
      generateInsights: sl(),
      analyzeWithAIAdvisor: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetPersona(sl()));
  sl.registerLazySingleton(() => UpdatePersona(sl()));
  sl.registerLazySingleton(() => RecordEmotionalState(sl()));
  sl.registerLazySingleton(() => AddGoal(sl()));
  sl.registerLazySingleton(() => UpdateGoal(sl()));
  sl.registerLazySingleton(() => DeleteGoal(sl()));
  sl.registerLazySingleton(() => UpdatePersonality(sl()));
  sl.registerLazySingleton(() => UpdateInteractionPreference(sl()));
  sl.registerLazySingleton(() => UpdateMotivationFactors(sl()));
  sl.registerLazySingleton(() => GenerateInsights(sl()));
  sl.registerLazySingleton(() => AnalyzeWithAIAdvisor(sl()));

  // Repository
  sl.registerLazySingleton<PersonaRepository>(
    () => PersonaRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  // For testing purposes, we'll use the mock data source
  // In production, you would use the remote data source
  sl.registerLazySingleton<PersonaRemoteDataSource>(
    () => PersonaRemoteDataSourceImpl(
      client: sl(),
      authService: sl(),
    ),
  );

  // Mock data source for testing
  sl.registerLazySingleton(() => PersonaMockDataSource());

  // External
  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton(() => http.Client());
  }

  // Check if AuthService is already registered
  if (!sl.isRegistered<AuthService>()) {
    sl.registerLazySingleton<AuthService>(() => AuthService());
  }
}
