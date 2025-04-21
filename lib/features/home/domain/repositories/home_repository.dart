// features/home/domain/repositories/home_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/home_data.dart';
import '../entities/home_feature.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeData>> getHomeData();
  Future<Either<Failure, List<HomeFeature>>> getHomeFeatures();
}
