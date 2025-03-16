// features/home/domain/repositories/home_repository.dart
import 'package:dartz/dartz.dart';
import '../entities/home_feature.dart';
import '../../../../core/error/failures.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<HomeFeature>>> getHomeFeatures();
}
