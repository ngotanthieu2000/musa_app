import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:musa_app/features/auth/domain/repositories/auth_repository.dart';

part 'splash_event.dart';
part 'splash_state.dart';

@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepository _authRepository;

  SplashBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const SplashInitial()) {
    on<InitializeSplash>(_onInitializeSplash);
  }

  Future<void> _onInitializeSplash(
    InitializeSplash event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashLoading());
    try {
      // Wait for a moment to show splash screen
      await Future.delayed(const Duration(seconds: 2));
      
      // Check if user is authenticated
      final result = await _authRepository.isLoggedIn();
      final isAuthenticated = result.fold(
        (failure) => false,
        (isLoggedIn) => isLoggedIn,
      );
      
      emit(SplashLoaded(isAuthenticated: isAuthenticated));
    } catch (e) {
      emit(SplashError(message: e.toString()));
    }
  }
} 