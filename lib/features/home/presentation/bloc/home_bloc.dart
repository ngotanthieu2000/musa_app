// features/home/presentation/bloc/home_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/usecases/get_home_data.dart';
import '../../../../core/usecases/usecase.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeData getHomeData;

  HomeBloc({required this.getHomeData}) : super(const HomeState.initial()) {
    on<FetchHomeData>(_onFetchHomeData);
  }

  Future<void> _onFetchHomeData(
    FetchHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeState.loading());
    
    final result = await getHomeData(const NoParams());
    
    emit(result.fold(
      (failure) => HomeState.error(failure.message),
      (homeData) => HomeState.loaded(homeData),
    ));
  }
}
