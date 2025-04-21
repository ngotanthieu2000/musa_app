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
    bool success = true,
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
    
    // Xây dựng Map chuẩn hóa
    var standardJson = Map<String, dynamic>.from(json);
    
    // Đảm bảo có success field
    if (!standardJson.containsKey('success')) {
      standardJson['success'] = true;
    }
    
    // Xử lý tokens nếu nằm trong object con
    if (standardJson.containsKey('tokens') && standardJson['tokens'] is Map) {
      var tokens = standardJson['tokens'] as Map<String, dynamic>;
      
      // Đưa tokens lên cấp cao nhất
      standardJson['access_token'] = tokens['access_token'] ?? 
                                    tokens['accessToken'] ??
                                    standardJson['access_token'];
      standardJson['refresh_token'] = tokens['refresh_token'] ?? 
                                     tokens['refreshToken'] ??
                                     standardJson['refresh_token'];
      standardJson['expires_at'] = tokens['expires_at'] ?? 
                                  tokens['expiresAt'] ??
                                  standardJson['expires_at'];
    }
    
    // Đảm bảo user object được xử lý đúng
    if (standardJson.containsKey('user') && standardJson['user'] is Map) {
      try {
        var userJson = standardJson['user'] as Map<String, dynamic>;
        var user = UserModel.fromJson(userJson);
        standardJson['user'] = user.toJson();
      } catch (e) {
        print('Error parsing user in AuthResponse: $e');
        standardJson.remove('user');
      }
    }
    
    print('Standardized JSON for AuthResponse: $standardJson');
    return _$AuthResponseFromJson(standardJson);
  }
  
  @override
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
  
  @override
  String toString() {
    return 'AuthResponse{success: $success, accessToken: ${accessToken != null ? '[present]' : 'null'}, refreshToken: ${refreshToken != null ? '[present]' : 'null'}, user: $user}';
  }
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