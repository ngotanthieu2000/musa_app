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
import '../../../../core/error/api_error_type.dart';

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
      emit(AuthError(
        message: 'Email không hợp lệ',
        errorType: ApiErrorType.validation
      ));
      return;
    }
    
    if (event.password.length < 6) {
      emit(AuthError(
        message: 'Mật khẩu phải có ít nhất 6 ký tự',
        errorType: ApiErrorType.validation
      ));
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
      (failure) => emit(AuthError(
        message: failure.message,
        errorType: failure.errorType,
        data: failure.data
      )),
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
      emit(AuthError(
        message: 'Email không hợp lệ',
        errorType: ApiErrorType.validation
      ));
      return;
    }
    
    if (event.password.length < 6) {
      emit(AuthError(
        message: 'Mật khẩu phải có ít nhất 6 ký tự',
        errorType: ApiErrorType.validation
      ));
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
      (failure) => emit(AuthError(
        message: failure.message,
        errorType: failure.errorType,
        data: failure.data
      )),
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
      (failure) => emit(AuthError(
        message: failure.message,
        errorType: failure.errorType,
        data: failure.data
      )),
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
  
  String _mapFailureToMessage(Failure failure) {
    return failure.userFriendlyMessage;
  }
}
