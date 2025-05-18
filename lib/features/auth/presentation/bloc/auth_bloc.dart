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
import '../../../../features/profile/presentation/bloc/profile_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final IsLoggedInUseCase _isLoggedInUseCase;
  final ProfileBloc? _profileBloc;

  AuthBloc({
    required RegisterUseCase registerUseCase,
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required RefreshTokenUseCase refreshTokenUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required IsLoggedInUseCase isLoggedInUseCase,
    ProfileBloc? profileBloc,
  })  : _registerUseCase = registerUseCase,
        _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _refreshTokenUseCase = refreshTokenUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _isLoggedInUseCase = isLoggedInUseCase,
        _profileBloc = profileBloc,
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

    print('AuthBloc: Checking authentication status');
    final result = await _isLoggedInUseCase(const NoParams());

    result.fold(
      (failure) {
        print('AuthBloc: Error checking auth status: ${failure.message}');
        emit(AuthUnauthenticated());
      },
      (isLoggedIn) {
        print('AuthBloc: Auth status check result: $isLoggedIn');
        if (isLoggedIn) {
          // If logged in, get the current user which will also set up the token
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

    if (event.password.length < 8) {
      emit(AuthError(
        message: 'Mật khẩu phải có ít nhất 8 ký tự',
        errorType: ApiErrorType.validation
      ));
      return;
    }

    // Kiểm tra mật khẩu có chứa chữ hoa, chữ thường và số
    bool hasUppercase = event.password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = event.password.contains(RegExp(r'[a-z]'));
    bool hasDigits = event.password.contains(RegExp(r'[0-9]'));

    if (!hasUppercase || !hasLowercase || !hasDigits) {
      List<String> requirements = [];
      if (!hasUppercase) requirements.add('chữ hoa');
      if (!hasLowercase) requirements.add('chữ thường');
      if (!hasDigits) requirements.add('số');

      emit(AuthError(
        message: 'Mật khẩu phải chứa: ${requirements.join(', ')}',
        errorType: ApiErrorType.validation
      ));
      return;
    }

    // Kiểm tra mật khẩu xác nhận
    if (event.password != event.confirmPassword) {
      emit(AuthError(
        message: 'Mật khẩu xác nhận không khớp',
        errorType: ApiErrorType.validation
      ));
      return;
    }

    try {
      print('AuthBloc: Attempting to register user: ${event.email}');

      // Call real register API
      final result = await _registerUseCase(
        RegisterParams(
          email: event.email,
          password: event.password,
          confirmPassword: event.confirmPassword,
          firstName: event.firstName,
          lastName: event.lastName,
        ),
      );

      result.fold(
        (failure) {
          print('AuthBloc: Registration failed with error: ${failure.message}');
          emit(AuthError(
            message: failure.message,
            errorType: failure.errorType,
            data: failure.data
          ));
        },
        (user) {
          print('AuthBloc: Registration successful for user: ${user.email}');
          emit(AuthAuthenticated(user: user));

          // Lấy thông tin profile sau khi đăng ký thành công
          _profileBloc?.add(GetProfileEvent());
        },
      );
    } catch (e) {
      print('AuthBloc: Unexpected error during registration: $e');
      emit(AuthError(
        message: 'Unexpected error: $e',
        errorType: ApiErrorType.unknown
      ));
    }
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
      (user) {
        emit(AuthAuthenticated(user: user));

        // Lấy thông tin profile sau khi đăng nhập thành công
        _profileBloc?.add(GetProfileEvent());
      },
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
    final currentState = state;

    final result = await _refreshTokenUseCase(
      RefreshTokenParams(refreshToken: event.refreshToken),
    );

    result.fold(
      (failure) {
        // Nếu refresh token thất bại, đăng xuất người dùng
        if (failure is AuthFailure) {
          print('AuthBloc: Token refresh failed, logging out user');
          add(AuthLogoutEvent());
        }
      },
      (tokens) {
        // Nếu refresh thành công và hiện tại đã có user (vẫn giữ trạng thái đã xác thực)
        if (currentState is AuthAuthenticated) {
          print('AuthBloc: Token refreshed successfully, keeping authenticated state');
          // Không cần thay đổi trạng thái, chỉ cập nhật token trong repository
        }
      },
    );
  }

  Future<void> _onAuthGetCurrentUser(
    AuthGetCurrentUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthAuthenticated) return; // Already have user info

    emit(AuthLoading());
    print('AuthBloc: Getting current user');

    final result = await _getCurrentUserUseCase(const NoParams());

    result.fold(
      (failure) {
        print('AuthBloc: Failed to get current user: ${failure.message}');
        // If we get an auth error, the token might be invalid
        if (failure is AuthFailure || failure.errorType == ApiErrorType.auth) {
          print('AuthBloc: Auth error, logging out user');
          add(AuthLogoutEvent());
        }
        emit(AuthUnauthenticated());
      },
      (user) {
        print('AuthBloc: Successfully got current user: ${user.email}');
        emit(AuthAuthenticated(user: user));

        // Lấy thông tin profile sau khi lấy thông tin user hiện tại thành công
        print('AuthBloc: Fetching profile information');
        _profileBloc?.add(GetProfileEvent());
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.userFriendlyMessage;
  }
}
