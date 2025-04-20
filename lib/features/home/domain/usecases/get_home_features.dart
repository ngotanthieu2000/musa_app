// features/home/domain/usecases/get_home_features.dart
import 'package:dartz/dartz.dart';
import '../repositories/home_repository.dart';
import '../entities/home_feature.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetHomeFeatures implements UseCase<List<HomeFeature>, NoParams> {
  final HomeRepository repository;

  GetHomeFeatures({required this.repository});

  @override
  Future<Either<Failure, List<HomeFeature>>> call(NoParams params) async {
    // Tạm thời trả về danh sách trống
    return Right([]);
  }
}
