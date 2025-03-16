// features/home/domain/usecases/get_home_features.dart
import 'package:dartz/dartz.dart';
import '../repositories/home_repository.dart';
import '../entities/home_feature.dart';
import '../../../../core/error/failures.dart';

class GetHomeFeatures {
  final HomeRepository repository;

  GetHomeFeatures({required this.repository});

  Future<Either<Failure, List<HomeFeature>>> call() async {
    return await repository.getHomeFeatures();
  }
}
