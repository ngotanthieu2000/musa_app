part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.checkAuthStatus() = CheckAuthStatus;
  
  const factory AuthEvent.loginRequested({
    required String email,
    required String password,
  }) = LoginRequested;
  
  const factory AuthEvent.registerRequested({
    required String name,
    required String email,
    required String password,
  }) = RegisterRequested;
  
  const factory AuthEvent.logoutRequested() = LogoutRequested;
} 