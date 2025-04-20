import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/is_logged_in_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/refresh_token_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final IsLoggedInUseCase _isLoggedInUseCase;
  
  AuthBloc({
    required RegisterUseCase registerUseCase,
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required RefreshTokenUseCase refreshTokenUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required IsLoggedInUseCase isLoggedInUseCase,
  })  : _registerUseCase = registerUseCase,
        _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _refreshTokenUseCase = refreshTokenUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _isLoggedInUseCase = isLoggedInUseCase,
        super(AuthInitial()) {
    on<AuthCheckStatusEvent>(_onAuthCheckStatus);
    on<AuthRegisterEvent>(_onAuthRegister);
    on<AuthLoginEvent>(_onAuthLogin);
    on<AuthLogoutEvent>(_onAuthLogout);
    on<AuthRefreshTokenEvent>(_onAuthRefreshToken);
    on<AuthGetCurrentUserEvent>(_onAuthGetCurrentUser);
    on<AuthEnterGuestModeEvent>(_onEnterGuestMode);
    on<AuthExitGuestModeEvent>(_onExitGuestMode);
  }
  
  Future<void> _onAuthCheckStatus(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _isLoggedInUseCase(const NoParams());
    
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (isLoggedIn) {
        if (isLoggedIn) {
          add(AuthGetCurrentUserEvent());
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }
  
  Future<void> _onAuthRegister(
    AuthRegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    // Simple validation of email and password
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    
    if (!emailRegExp.hasMatch(event.email)) {
      emit(AuthError(message: 'Invalid email'));
      return;
    }
    
    if (event.password.length < 6) {
      emit(AuthError(message: 'Password must be at least 6 characters'));
      return;
    }
    
    // Call real register API
    final result = await _registerUseCase(
      RegisterParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );
    
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }
  
  Future<void> _onAuthLogin(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    // Simple validation of email and password
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    
    if (!emailRegExp.hasMatch(event.email)) {
      emit(AuthError(message: 'Invalid email'));
      return;
    }
    
    if (event.password.length < 6) {
      emit(AuthError(message: 'Password must be at least 6 characters'));
      return;
    }
    
    // Call real login API
    final result = await _loginUseCase(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );
    
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }
  
  Future<void> _onAuthLogout(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _logoutUseCase(const NoParams());
    
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (_) => emit(AuthUnauthenticated()),
    );
  }
  
  Future<void> _onAuthRefreshToken(
    AuthRefreshTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _refreshTokenUseCase(
      RefreshTokenParams(refreshToken: event.refreshToken),
    );
    
    result.fold(
      (failure) {
        // If token refresh fails, change to unauthenticated state
        if (failure is AuthFailure) {
          emit(AuthUnauthenticated());
        }
      },
      (tokens) => null, // If refresh is successful, no state change needed
    );
  }
  
  Future<void> _onAuthGetCurrentUser(
    AuthGetCurrentUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthAuthenticated) return; // Already have user info
    
    emit(AuthLoading());
    
    final result = await _getCurrentUserUseCase(const NoParams());
    
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }
  
  // Handler for guest mode
  Future<void> _onEnterGuestMode(
    AuthEnterGuestModeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    // No actual authentication needed, just transition to guest mode
    emit(AuthGuestMode());
    
    // Log the action for analytics purposes
    if (kDebugMode) {
      print('User entered guest mode');
    }
  }
  
  // Handler for exiting guest mode
  Future<void> _onExitGuestMode(
    AuthExitGuestModeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    // No actual authentication needed, just transition to unauthenticated state
    emit(AuthUnauthenticated());
    
    // Log the action for analytics purposes
    if (kDebugMode) {
      print('User exited guest mode');
    }
  }
  
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message;
      case NetworkFailure:
        return 'No network connection. Please check your connection.';
      case AuthFailure:
        return failure.message;
      default:
        return 'An unknown error occurred.';
    }
  }
}
