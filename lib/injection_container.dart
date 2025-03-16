// lib/injection_container.dart
import 'package:get_it/get_it.dart';
import 'features/home/data/datasources/home_remote_data_source.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/get_home_features.dart';
import 'features/home/presentation/bloc/home_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async { // Thay đổi kiểu trả về thành Future<void>
  // BLoC
  sl.registerFactory(() => HomeBloc(getHomeFeatures: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetHomeFeatures(repository: sl()));

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );
}