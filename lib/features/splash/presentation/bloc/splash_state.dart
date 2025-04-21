part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  const SplashState();
  
  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashLoading extends SplashState {
  const SplashLoading();
}

class SplashLoaded extends SplashState {
  final bool isAuthenticated;
  
  const SplashLoaded({
    required this.isAuthenticated,
  });
  
  @override
  List<Object> get props => [isAuthenticated];
}

class SplashError extends SplashState {
  final String message;
  
  const SplashError({
    required this.message,
  });
  
  @override
  List<Object> get props => [message];
} 