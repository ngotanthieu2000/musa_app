// features/home/presentation/bloc/home_state.dart
part of 'home_bloc.dart'; // Khai báo part of

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<HomeFeature> features;

  const HomeLoaded({required this.features});

  @override
  List<Object> get props => [features];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
}
