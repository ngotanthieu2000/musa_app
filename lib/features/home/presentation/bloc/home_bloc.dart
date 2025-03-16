// features/home/presentation/bloc/home_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_home_features.dart';
import '../../domain/entities/home_feature.dart';
import '../../../../core/error/failures.dart';

part 'home_event.dart'; // Khai báo part
part 'home_state.dart'; // Khai báo part

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeFeatures getHomeFeatures;

  HomeBloc({required this.getHomeFeatures}) : super(HomeInitial()) {
    on<FetchHomeFeatures>(_onFetchHomeFeatures);
  }

  Future<void> _onFetchHomeFeatures(
    FetchHomeFeatures event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    final result = await getHomeFeatures();
    result.fold(
      (failure) => emit(HomeError(message: _mapFailureToMessage(failure))),
      (features) => emit(HomeLoaded(features: features)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error';
      default:
        return 'Unexpected error';
    }
  }
}
