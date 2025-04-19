// features/home/presentation/bloc/home_event.dart
part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.fetchData() = FetchHomeData;
}
