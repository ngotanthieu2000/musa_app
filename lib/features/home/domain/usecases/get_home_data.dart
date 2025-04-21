import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/home_data.dart';
import '../repositories/home_repository.dart';

@injectable
class GetHomeData implements UseCase<HomeData, NoParams> {
  final HomeRepository repository;

  GetHomeData({required this.repository});

  @override
  Future<Either<Failure, HomeData>> call(NoParams params) async {
    return await repository.getHomeData();
  }
} 