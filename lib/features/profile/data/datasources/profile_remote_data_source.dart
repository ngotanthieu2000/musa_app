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
      print('DEBUG: Calling REAL API PUT /api/v1/profile with data: $profileData');
      final data = await apiClient.put('/api/v1/profile', data: profileData);
      print('DEBUG: API Response received: $data');

      // Kiểm tra phản hồi từ API
      if (data is Map<String, dynamic>) {
        // Trường hợp 1: Phản hồi là profile đầy đủ
        if (data.containsKey('id') && (data.containsKey('first_name') || data.containsKey('email'))) {
          print('DEBUG: Received complete profile data from API');

          // Chuyển đổi first_name, last_name thành name để phù hợp với model
          String name = "";
          if (data.containsKey('first_name') && data.containsKey('last_name')) {
            name = "${data['last_name']} ${data['first_name']}";
          } else if (data.containsKey('display_name')) {
            name = data['display_name'];
          } else if (data.containsKey('first_name')) {
            name = data['first_name'];
          }

          // Tạo map mới với trường name
          Map<String, dynamic> profileMap = Map.from(data);
          profileMap['name'] = name;

          return ProfileModel.fromJson(profileMap);
        }
        // Trường hợp 2: Phản hồi là thông báo thành công
        else if (data.containsKey('message') && (
            data['message'] == 'Profile updated successfully' ||
            data['message'].toString().contains('success')
        )) {
          print('DEBUG: Received success message, fetching latest profile');

          // Tải lại profile từ API
          try {
            final latestProfile = await apiClient.get('/api/v1/profile');
            print('DEBUG: Latest profile fetched: $latestProfile');

            if (latestProfile is Map<String, dynamic> && latestProfile.containsKey('id')) {
              // Chuyển đổi first_name, last_name thành name
              String name = "";
              if (latestProfile.containsKey('first_name') && latestProfile.containsKey('last_name')) {
                name = "${latestProfile['last_name']} ${latestProfile['first_name']}";
              } else if (latestProfile.containsKey('display_name')) {
                name = latestProfile['display_name'];
              } else if (latestProfile.containsKey('first_name')) {
                name = latestProfile['first_name'];
              }

              // Tạo map mới với trường name
              Map<String, dynamic> profileMap = Map.from(latestProfile);
              profileMap['name'] = name;

              return ProfileModel.fromJson(profileMap);
            }
          } catch (fetchError) {
            print('DEBUG: Error fetching latest profile: $fetchError');
          }

          // Nếu không thể lấy profile mới, tạo một profile tạm thời với ID
          print('DEBUG: Creating minimal profile with updated fields');

          // Tạo profile tạm thời với các trường đã cập nhật
          String name = "";
          if (profileData.containsKey('first_name') && profileData.containsKey('last_name')) {
            name = "${profileData['last_name']} ${profileData['first_name']}";
          } else if (profileData.containsKey('display_name')) {
            name = profileData['display_name'];
          }

          return ProfileModel.fromJson({
            'id': profileData['id'],
            'name': name,
            'phone_number': profileData['phone_number'],
            'bio': profileData['bio'],
            'updated_at': DateTime.now().toIso8601String(),
          });
        }
      }

      // Nếu không xử lý được phản hồi, ném ngoại lệ
      throw ServerException(
        message: 'Invalid response format from server: $data',
        errorType: ApiErrorType.unknown,
      );
    } catch (e) {
      print('DEBUG: Error in updateProfile: $e');
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