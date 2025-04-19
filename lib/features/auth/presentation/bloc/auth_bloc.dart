import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/logout_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final LogoutUser logoutUser;

  AuthBloc({
    required this.loginUser,
    required this.registerUser,
    required this.logoutUser,
  }) : super(const AuthState.initial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    
    // TODO: Implement check auth status logic
    // Check if user is logged in from local storage or token
    // For now, assuming user is not authenticated
    
    emit(const AuthState.unauthenticated());
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    
    final result = await loginUser(
      LoginParams(email: event.email, password: event.password),
    );
    
    emit(result.fold(
      (failure) => AuthState.error(failure),
      (user) => AuthState.authenticated(user),
    ));
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    
    final result = await registerUser(
      RegisterParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    
    emit(result.fold(
      (failure) => AuthState.error(failure),
      (user) => AuthState.authenticated(user),
    ));
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    
    final result = await logoutUser(const NoParams());
    
    emit(result.fold(
      (failure) => AuthState.error(failure),
      (_) => const AuthState.unauthenticated(),
    ));
  }
}
