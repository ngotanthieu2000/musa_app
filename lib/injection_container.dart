// lib/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'features/home/data/datasources/home_remote_data_source.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/get_home_features.dart';
import 'features/home/domain/usecases/get_home_data.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/tasks/data/repositories/task_repository_impl.dart';
import 'features/tasks/data/datasources/task_remote_data_source.dart';
import 'features/tasks/domain/repositories/task_repository.dart';
import 'features/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/network';
import 'core/storage/token_storage.dart';
import 'core/storage/secure_storage.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/refresh_token_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'core/usecases/usecase.dart';
import 'config/env_config.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => Dio());
  
  // Core
  sl.registerLazySingleton(
    () => ApiClient(
      baseUrl: EnvConfig.apiBaseUrl, 
      dio: sl<Dio>()
    ),
  );
  sl.registerLazySingleton(() => TokenStorage(secureStorage: sl<FlutterSecureStorage>()));
  sl.registerLazySingleton(() => SecureStorage(storage: sl<FlutterSecureStorage>()));
  
  // Features - Auth
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  
  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      apiClient: sl<ApiClient>(),
      secureStorage: sl<SecureStorage>(),
    ),
  );
  
  // Use cases
  sl.registerLazySingleton(
    () => RegisterUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => LoginUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => LogoutUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => RefreshTokenUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => GetCurrentUserUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => IsLoggedInUseCase(sl<AuthRepository>()),
  );
  
  // Blocs
  sl.registerFactory(
    () => AuthBloc(
      registerUseCase: sl<RegisterUseCase>(),
      loginUseCase: sl<LoginUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      refreshTokenUseCase: sl<RefreshTokenUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      isLoggedInUseCase: sl<IsLoggedInUseCase>(),
    ),
  );

  // Home feature
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: sl<HomeRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton(
    () => GetHomeData(repository: sl<HomeRepository>()),
  );

  sl.registerLazySingleton(
    () => GetHomeFeatures(repository: sl<HomeRepository>()),
  );

  sl.registerFactory(
    () => HomeBloc(getHomeData: sl<GetHomeData>()),
  );

  // Tasks
  sl.registerFactory(
    () => TasksBloc(repository: sl()),
  );

  // Repositories
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  // External
  sl.registerLazySingleton<http.Client>(() => http.Client());
}