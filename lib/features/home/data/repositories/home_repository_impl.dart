// features/home/data/repositories/home_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/entities/home_feature.dart';
import '../datasources/home_remote_data_source.dart';
import '../../../../core/error/failures.dart';
import '../models/home_feature_model.dart'; // Import lớp HomeFeatureModel

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

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
      return const Left(ServerFailure());
    }
  }
}
