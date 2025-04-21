// features/home/data/repositories/home_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/api_error_type.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/entities/home_feature.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';
import '../models/home_data_model.dart';
import '../models/home_feature_model.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, HomeData>> getHomeData() async {
    try {
      final homeDataModel = await remoteDataSource.getHomeData();
      return Right(homeDataModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(
        message: 'Không thể tải dữ liệu trang chủ',
        errorType: ApiErrorType.server,
      ));
    }
  }

  @override
  Future<Either<Failure, List<HomeFeature>>> getHomeFeatures() async {
    try {
      final features = await remoteDataSource.getHomeFeatures();
      return Right(features.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(
        message: 'Không thể tải danh sách tính năng',
        errorType: ApiErrorType.server,
      ));
    }
  }
}
