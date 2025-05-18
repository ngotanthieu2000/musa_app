import 'dart:convert';

import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/api_error_type.dart';
import '../../../../core/network_helper.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/auth_request_models.dart';
import '../models/auth_response_models.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Register new user
  Future<AuthResponse> register(String firstName, String lastName, String email, String password, String confirmPassword);

  /// Login user
  Future<AuthResponse> login(String email, String password);

  /// Refresh token
  Future<AuthResponse> refreshToken(String refreshToken);

  /// Logout user
  Future<void> logout();

  /// Get current user information
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthResponse> register(String firstName, String lastName, String email, String password, String confirmPassword) async {
    try {
      print('AuthRemoteDataSource: Attempting register for: $email');
      final response = await apiClient.post(
        '/api/v1/auth/register',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
        },
      );

      print('AuthRemoteDataSource: Raw register response: $response');
      return AuthResponse.fromJson(response);
    } catch (e) {
      print('AuthRemoteDataSource: Register error: $e');
      throw ServerException(
        message: e.toString(),
        errorType: ApiErrorType.server
      );
    }
  }

  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      print('AuthRemoteDataSource: Attempting login for: $email');
      final response = await apiClient.post(
        '/api/v1/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      print('AuthRemoteDataSource: Raw login response: $response');

      // Đảm bảo response là Map
      if (response is! Map<String, dynamic>) {
        print('AuthRemoteDataSource: Invalid response type: ${response.runtimeType}');
        throw ServerException(
          message: 'Invalid response format',
          errorType: ApiErrorType.server
        );
      }

      // Tạo bản sao để không ảnh hưởng đến dữ liệu gốc
      Map<String, dynamic> processedResponse = Map<String, dynamic>.from(response);

      // Chắc chắn có trường success
      if (!processedResponse.containsKey('success')) {
        processedResponse['success'] = true;
      }

      // Dựng UserModel từ User object trong response nếu có
      UserModel? user;
      if (processedResponse.containsKey('user') && processedResponse['user'] != null) {
        try {
          user = UserModel.fromJson(processedResponse['user']);
        } catch (e) {
          print('AuthRemoteDataSource: Error parsing user data: $e');
        }
      }

      // Tạo AuthResponse thủ công để đảm bảo đúng cấu trúc
      var authResponse = AuthResponse(
        success: true,
        accessToken: processedResponse['access_token'],
        refreshToken: processedResponse['refresh_token'],
        user: user,
      );

      // In log để debug
      print('AuthRemoteDataSource: Final authResponse: $authResponse');
      print('AuthRemoteDataSource: Token values: ${authResponse.accessToken}, ${authResponse.refreshToken}');

      return authResponse;
    } catch (e) {
      if (e is ServerException) rethrow;
      print('AuthRemoteDataSource: Login error: $e');
      throw ServerException(
        message: e.toString(),
        errorType: ApiErrorType.server
      );
    }
  }

  @override
  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await apiClient.post(
        '/api/v1/auth/refresh',
        data: {
          'refresh_token': refreshToken,
        },
      );

      return AuthResponse.fromJson(response);
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        errorType: ApiErrorType.server
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.post('/api/v1/auth/logout');
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        errorType: ApiErrorType.server
      );
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.get('/api/v1/auth/me');
      return UserModel.fromJson(response['user']);
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        errorType: ApiErrorType.server
      );
    }
  }
}