import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../features/auth/data/datasources/auth_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_user.dart';
import '../../features/auth/domain/usecases/register_user.dart';
import '../../features/auth/domain/usecases/logout_user.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/home/data/datasources/home_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_home_data.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/tasks/data/datasources/tasks_data_source.dart';
import '../../features/tasks/data/repositories/tasks_repository_impl.dart';
import '../../features/tasks/domain/repositories/tasks_repository.dart';
import '../../features/tasks/domain/usecases/get_tasks.dart';
import '../../features/tasks/domain/usecases/add_task.dart';
import '../../features/tasks/domain/usecases/update_task.dart';
import '../../features/tasks/domain/usecases/delete_task.dart';
import '../../features/tasks/presentation/bloc/tasks_bloc.dart';
import '../../core/theme/app_theme_manager.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Core
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl()));

  // Auth Feature
  // Data sources
  sl.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUser(repository: sl()));
  sl.registerLazySingleton(() => RegisterUser(repository: sl()));
  sl.registerLazySingleton(() => LogoutUser(repository: sl()));

  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      loginUser: sl(),
      registerUser: sl(),
      logoutUser: sl(),
    ),
  );

  // Home Feature
  // Data sources
  sl.registerLazySingleton<HomeDataSource>(
    () => HomeDataSourceImpl(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(dataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetHomeData(repository: sl()));

  // BLoC
  sl.registerFactory(
    () => HomeBloc(
      getHomeData: sl(),
    ),
  );

  // Tasks Feature
  // Data sources
  sl.registerLazySingleton<TasksDataSource>(
    () => TasksDataSourceImpl(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<TasksRepository>(
    () => TasksRepositoryImpl(dataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTasks(repository: sl()));
  sl.registerLazySingleton(() => AddTask(repository: sl()));
  sl.registerLazySingleton(() => UpdateTask(repository: sl()));
  sl.registerLazySingleton(() => DeleteTask(repository: sl()));

  // BLoC
  sl.registerFactory(
    () => TasksBloc(
      getTasks: sl(),
      addTask: sl(),
      updateTask: sl(),
      deleteTask: sl(),
    ),
  );
} 