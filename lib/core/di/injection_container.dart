import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/refresh_token_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/is_logged_in_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/datasources/profile_local_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile.dart';
import '../../features/profile/domain/usecases/update_profile.dart';
import '../../features/profile/domain/usecases/change_password.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';

import '../../features/navigation/presentation/bloc/navigation_bloc.dart';

import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_home_data.dart';
import '../../features/home/domain/usecases/get_home_features.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';

import '../../features/tasks/data/datasources/task_remote_data_source.dart';
import '../../features/tasks/data/repositories/task_repository_impl.dart';
import '../../features/tasks/domain/repositories/task_repository.dart';
import '../../features/tasks/presentation/bloc/tasks_bloc.dart';

import '../../features/splash/presentation/bloc/splash_bloc.dart';

// import '../../features/persona/di/persona_injection_container.dart' as persona_di;

import '../../core/network_helper.dart';
import '../../core/network_info.dart';
import '../../core/storage/token_storage.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/utils/notification_service.dart';
import '../../core/api/api_interceptor.dart';
import '../../core/services/image_upload_service.dart';
import '../../core/services/auth_service.dart';
import '../../config/env_config.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => Dio());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Core
  sl.registerLazySingleton(() => TokenStorage(secureStorage: sl<FlutterSecureStorage>()));
  sl.registerLazySingleton(() => SecureStorage(storage: sl<FlutterSecureStorage>()));
  sl.registerLazySingleton(() => NotificationService());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // API Client
  sl.registerLazySingleton(
    () => ApiClient(
      baseUrl: EnvConfig.apiBaseUrl,
      dio: sl<Dio>(),
      secureStorage: sl<SecureStorage>(),
    ),
  );

  // Services
  sl.registerLazySingleton(() => ImageUploadService(apiClient: sl<ApiClient>()));
  sl.registerLazySingleton(() => AuthService());

  // Profile Feature - Register first as AuthBloc depends on it
  // Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl<ProfileRemoteDataSource>(),
      localDataSource: sl<ProfileLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
      imageUploadService: sl<ImageUploadService>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProfile(sl<ProfileRepository>()));
  sl.registerLazySingleton(() => UpdateProfile(sl<ProfileRepository>()));
  sl.registerLazySingleton(() => ChangePassword(sl<ProfileRepository>()));

  // Bloc
  sl.registerFactory(
    () => ProfileBloc(
      getProfile: sl<GetProfile>(),
      updateProfile: sl<UpdateProfile>(),
      changePassword: sl<ChangePassword>(),
    ),
  );

  // Auth Feature
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      apiClient: sl<ApiClient>(),
      secureStorage: sl<SecureStorage>(),
      remoteDataSource: sl<AuthRemoteDataSource>(),
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

  // Add TokenInterceptor with required dependencies
  sl<Dio>().interceptors.add(
    TokenInterceptor(
      secureStorage: sl<SecureStorage>(),
      authRepository: sl<AuthRepository>(),
      dio: sl<Dio>(),
    ),
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
      profileBloc: sl<ProfileBloc>(),
    ),
  );

  // Home feature
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
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
  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(
      client: sl<http.Client>(),
      authService: sl<AuthService>(),
      baseUrl: EnvConfig.apiBaseUrl,
    ),
  );

  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      remoteDataSource: sl<TaskRemoteDataSource>(),
    ),
  );

  sl.registerFactory(
    () => TasksBloc(repository: sl<TaskRepository>()),
  );

  // Navigation Feature
  sl.registerFactory(() => NavigationBloc());

  // Splash Feature
  sl.registerFactory(
    () => SplashBloc(
      authRepository: sl<AuthRepository>(),
    ),
  );

  // Initialize Persona Feature
  // await persona_di.initPersonaFeature();
}