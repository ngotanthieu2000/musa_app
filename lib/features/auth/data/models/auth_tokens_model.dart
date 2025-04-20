import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/auth_tokens.dart';

part 'auth_tokens_model.g.dart';

@JsonSerializable()
class AuthTokensModel extends AuthTokens {
  const AuthTokensModel({
    required String accessToken,
    required String refreshToken,
    DateTime? expiresAt,
  }) : super(
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresAt: expiresAt,
  );
  
  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    // Handle both snake_case and camelCase field names
    final accessToken = json['access_token'] ?? json['accessToken'];
    final refreshToken = json['refresh_token'] ?? json['refreshToken'];
    
    if (accessToken == null || refreshToken == null) {
      throw FormatException('Missing required token fields in JSON: $json');
    }
    
    // Parse expires_at if present
    DateTime? expiresAt;
    final expiresAtRaw = json['expires_at'] ?? json['expiresAt'];
    if (expiresAtRaw != null && expiresAtRaw is String) {
      try {
        expiresAt = DateTime.parse(expiresAtRaw);
      } catch (e) {
        print('Error parsing expiresAt: $e');
        // Default to 1 hour from now if can't parse
        expiresAt = DateTime.now().add(const Duration(hours: 1));
      }
    } else {
      // Default expiry time
      expiresAt = DateTime.now().add(const Duration(hours: 1));
    }
    
    return AuthTokensModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }
  
  Map<String, dynamic> toJson() => _$AuthTokensModelToJson(this);
  
  factory AuthTokensModel.fromEntity(AuthTokens tokens) {
    return AuthTokensModel(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      expiresAt: tokens.expiresAt,
    );
  }
  
  AuthTokens toEntity() {
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }
} 