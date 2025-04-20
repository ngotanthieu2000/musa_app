import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'auth_response_models.g.dart';

// Model base cho response
@JsonSerializable()
class BaseResponse {
  final bool success;
  final String? message;
  final int? statusCode;
  
  BaseResponse({
    required this.success,
    this.message,
    this.statusCode,
  });
  
  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return _$BaseResponseFromJson(json);
  }
  
  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}

// Model cho response đăng ký và đăng nhập
@JsonSerializable()
class AuthResponse extends BaseResponse {
  @JsonKey(name: 'access_token')
  final String? accessToken;
  
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;
  
  final UserModel? user;
  
  AuthResponse({
    required bool success,
    String? message,
    int? statusCode,
    this.accessToken,
    this.refreshToken,
    this.expiresAt,
    this.user,
  }) : super(
    success: success,
    message: message,
    statusCode: statusCode,
  );
  
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // For debugging
    print('Raw AuthResponse JSON: $json');
    
    // Handle case when response comes in a nested structure
    if (json.containsKey('tokens') && json['tokens'] is Map<String, dynamic>) {
      var tokens = json['tokens'] as Map<String, dynamic>;
      var authJson = Map<String, dynamic>.from(json);
      
      // Move tokens fields to top level
      authJson['access_token'] = tokens['access_token'] ?? tokens['accessToken'];
      authJson['refresh_token'] = tokens['refresh_token'] ?? tokens['refreshToken'];
      authJson['expires_at'] = tokens['expires_at'] ?? tokens['expiresAt'];
      
      // Add default success value if not present
      if (!authJson.containsKey('success')) {
        authJson['success'] = true;
      }
      
      return _$AuthResponseFromJson(authJson);
    }
    
    // Handle flat structure where token fields are at top level
    if (!json.containsKey('success') && 
        (json.containsKey('access_token') || json.containsKey('accessToken'))) {
      var authJson = Map<String, dynamic>.from(json);
      authJson['success'] = true;
      return _$AuthResponseFromJson(authJson);
    }
    
    return _$AuthResponseFromJson(json);
  }
  
  @override
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

// Model cho response refresh token
@JsonSerializable()
class RefreshTokenResponse extends BaseResponse {
  @JsonKey(name: 'access_token')
  final String? accessToken;
  
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;
  
  RefreshTokenResponse({
    required bool success,
    String? message,
    int? statusCode,
    this.accessToken,
    this.refreshToken,
    this.expiresAt,
  }) : super(
    success: success,
    message: message,
    statusCode: statusCode,
  );
  
  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) => _$RefreshTokenResponseFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$RefreshTokenResponseToJson(this);
} 