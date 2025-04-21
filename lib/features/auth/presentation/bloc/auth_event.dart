part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

class AuthCheckStatusEvent extends AuthEvent {}

class AuthRegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String? name;
  
  const AuthRegisterEvent({
    required this.email,
    required this.password,
    this.name,
  });
  
  @override
  List<Object?> get props => [email, password, name];
}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;
  
  const AuthLoginEvent({
    required this.email,
    required this.password,
  });
  
  @override
  List<Object> get props => [email, password];
}

class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();
}

class AuthRefreshTokenEvent extends AuthEvent {
  final String refreshToken;
  
  const AuthRefreshTokenEvent({required this.refreshToken});
  
  @override
  List<Object> get props => [refreshToken];
}

class AuthGetCurrentUserEvent extends AuthEvent {}

// Remove guest mode events
// Event to enter guest mode without authentication
// class AuthEnterGuestModeEvent extends AuthEvent {}

// Event to exit guest mode and return to unauthenticated state
// class AuthExitGuestModeEvent extends AuthEvent {} 