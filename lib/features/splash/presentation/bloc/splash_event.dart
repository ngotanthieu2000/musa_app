part of 'splash_bloc.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object> get props => [];
}

class InitializeSplash extends SplashEvent {
  const InitializeSplash();
} 