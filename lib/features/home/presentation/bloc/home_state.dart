// features/home/presentation/bloc/home_state.dart
part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = HomeInitial;
  const factory HomeState.loading() = HomeLoading;
  const factory HomeState.loaded(HomeData homeData) = HomeLoaded;
  const factory HomeState.error(String message) = HomeError;
}
