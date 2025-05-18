// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) => BaseResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'statusCode': instance.statusCode,
    };

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'statusCode': instance.statusCode,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'user': instance.user,
    };

RefreshTokenResponse _$RefreshTokenResponseFromJson(
        Map<String, dynamic> json) =>
    RefreshTokenResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$RefreshTokenResponseToJson(
        RefreshTokenResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'statusCode': instance.statusCode,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'expires_at': instance.expiresAt?.toIso8601String(),
    };
