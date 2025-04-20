import 'package:json_annotation/json_annotation.dart';

part 'auth_request_models.g.dart';

// Model cho request đăng ký
@JsonSerializable()
class RegisterRequest {
  final String email;
  final String password;
  final String? name;
  
  RegisterRequest({
    required this.email,
    required this.password,
    this.name,
  });
  
  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

// Model cho request đăng nhập
@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;
  
  LoginRequest({
    required this.email,
    required this.password,
  });
  
  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

// Model cho request refresh token
@JsonSerializable()
class RefreshTokenRequest {
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  
  RefreshTokenRequest({
    required this.refreshToken,
  });
  
  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) => _$RefreshTokenRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);
} 