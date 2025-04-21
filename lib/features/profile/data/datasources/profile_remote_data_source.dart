import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/api_error_type.dart';
import '../../../../core/network_helper.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/mock/mock_api.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  /// Calls the /api/v1/profile endpoint.
  ///
  /// Throws [ServerException] for all error codes.
  Future<ProfileModel> getBasicProfile();

  /// Calls the /api/v1/profile/full endpoint.
  ///
  /// Throws [ServerException] for all error codes.
  Future<ProfileModel> getFullProfile();

  /// Calls the /api/v1/profile endpoint with a PUT method.
  ///
  /// Throws [ServerException] for all error codes.
  Future<ProfileModel> updateProfile(Map<String, dynamic> profileData);

  /// Calls the /api/v1/profile/preferences endpoint with a PUT method.
  ///
  /// Throws [ServerException] for all error codes.
  Future<ProfileModel> updatePreferences(Map<String, dynamic> preferencesData);

  /// Calls the /api/v1/profile/notifications endpoint with a PUT method.
  ///
  /// Throws [ServerException] for all error codes.
  Future<ProfileModel> updateNotificationSettings(Map<String, dynamic> notificationData);

  /// Calls the /api/v1/profile/health endpoint with a PUT method.
  ///
  /// Throws [ServerException] for all error codes.
  Future<ProfileModel> updateHealthData(Map<String, dynamic> healthData);

  /// Calls the /api/v1/profile/password endpoint with a PUT method.
  ///
  /// Throws [ServerException] for all error codes.
  Future<void> changePassword(String currentPassword, String newPassword);
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;
  // Sử dụng MockApi khi cần test mà backend chưa sẵn sàng
  final MockApi _mockApi = MockApi();
  
  // Đánh dấu có sử dụng mock API hay không
  final bool useMockApi = false; // Set false khi có API thực

  ProfileRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProfileModel> getBasicProfile() async {
    try {
      if (useMockApi) {
        // Sử dụng MockApi
        print('DEBUG: Using mock API for getBasicProfile');
        final Map<String, dynamic> data = await _mockApi.getProfile();
        return ProfileModel.fromJson(data);
      }
      
      // Sử dụng API thực
      print('DEBUG: Using real API for getBasicProfile');
      final data = await apiClient.get('/api/v1/profile');
      return ProfileModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: e.toString(),
        errorType: ApiErrorType.server,
      );
    }
  }

  @override
  Future<ProfileModel> getFullProfile() async {
    try {
      if (useMockApi) {
        // Sử dụng MockApi
        print('DEBUG: Using mock API for getFullProfile');
        final Map<String, dynamic> data = await _mockApi.getProfile();
        return ProfileModel.fromJson(data);
      }
      
      // Sử dụng API thực
      print('DEBUG: Using real API for getFullProfile');
      final data = await apiClient.get('/api/v1/profile/full');
      return ProfileModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: e.toString(),
        errorType: ApiErrorType.server,
      );
    }
  }

  @override
  Future<ProfileModel> updateProfile(Map<String, dynamic> profileData) async {
    try {
      if (useMockApi) {
        // Sử dụng MockApi
        print('DEBUG: Using mock API for updateProfile with data: $profileData');
        final Map<String, dynamic> data = await _mockApi.updateProfile(profileData);
        return ProfileModel.fromJson(data);
      }
      
      // Sử dụng API thực
      print('DEBUG: Using real API for updateProfile with data: $profileData');
      final data = await apiClient.put('/api/v1/profile', data: profileData);
      return ProfileModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: e.toString(),
        errorType: ApiErrorType.server,
      );
    }
  }

  @override
  Future<ProfileModel> updatePreferences(Map<String, dynamic> preferencesData) async {
    try {
      if (useMockApi) {
        // Sử dụng MockApi
        final Map<String, dynamic> data = await _mockApi.updateProfile({'preferences': preferencesData});
        return ProfileModel.fromJson(data);
      }
      
      // Sử dụng API thực
      final data = await apiClient.put('/api/v1/profile/preferences', data: preferencesData);
      return ProfileModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: e.toString(),
        errorType: ApiErrorType.server,
      );
    }
  }

  @override
  Future<ProfileModel> updateNotificationSettings(Map<String, dynamic> notificationData) async {
    try {
      if (useMockApi) {
        // Sử dụng MockApi
        final Map<String, dynamic> data = await _mockApi.updateProfile({'notification_settings': notificationData});
        return ProfileModel.fromJson(data);
      }
      
      // Sử dụng API thực
      final data = await apiClient.put('/api/v1/profile/notifications', data: notificationData);
      return ProfileModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: e.toString(),
        errorType: ApiErrorType.server,
      );
    }
  }

  @override
  Future<ProfileModel> updateHealthData(Map<String, dynamic> healthData) async {
    try {
      if (useMockApi) {
        // Sử dụng MockApi
        final Map<String, dynamic> data = await _mockApi.updateProfile({'health_data': healthData});
        return ProfileModel.fromJson(data);
      }
      
      // Sử dụng API thực
      final data = await apiClient.put('/api/v1/profile/health', data: healthData);
      return ProfileModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: e.toString(),
        errorType: ApiErrorType.server,
      );
    }
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      if (useMockApi) {
        // Giả lập thành công
        await Future.delayed(const Duration(seconds: 1));
        return;
      }
      
      // Sử dụng API thực
      await apiClient.put('/api/v1/profile/password', data: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'confirm_password': newPassword,
      });
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(
        message: e.toString(),
        errorType: ApiErrorType.server,
      );
    }
  }
} 