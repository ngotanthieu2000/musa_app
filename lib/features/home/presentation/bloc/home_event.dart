// features/home/presentation/bloc/home_event.dart
part of 'home_bloc.dart'; // Khai báo part of

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchHomeFeatures extends HomeEvent {}
