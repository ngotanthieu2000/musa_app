import 'package:equatable/equatable.dart';

class AuthTokens extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAt;
  
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });
  
  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt];
  
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  
  AuthTokens copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) {
    return AuthTokens(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
} 