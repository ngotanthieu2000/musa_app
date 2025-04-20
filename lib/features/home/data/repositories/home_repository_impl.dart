// features/home/data/repositories/home_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/entities/home_feature.dart';
import '../datasources/home_remote_data_source.dart';
import '../../../../core/error/failures.dart';
import '../models/home_feature_model.dart'; // Import lớp HomeFeatureModel

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, HomeData>> getHomeData() async {
    try {
      // Tạo dữ liệu mẫu tạm thời
      final homeData = HomeData(
        userName: 'User',
        todayTasks: [],
        goals: [],
        overallProgress: 0,
        tasksCompleted: 0,
        totalTasks: 0,
      );
      return Right(homeData);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get home data'));
    }
  }

  @override
  Future<Either<Failure, List<HomeFeature>>> getHomeFeatures() async {
    try {
      // Lấy dữ liệu từ RemoteDataSource
      final List<HomeFeatureModel> featureModels =
          await remoteDataSource.getHomeFeatures();

      // Chuyển đổi List<HomeFeatureModel> sang List<HomeFeature>
      final List<HomeFeature> features =
          featureModels.map((model) => model.toEntity()).toList();

      return Right(features);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get home features'));
    }
  }
}
