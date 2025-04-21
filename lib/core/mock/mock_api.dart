import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';

/// Class giả lập API để kiểm thử các tính năng khi API thực tế chưa sẵn sàng
class MockApi {
  static final MockApi _instance = MockApi._internal();
  factory MockApi() => _instance;
  MockApi._internal();

  // Mock dữ liệu profile
  final Map<String, dynamic> _profile = {
    'id': '1',
    'name': 'Nguyễn Văn A',
    'email': 'nguyenvana@example.com',
    'avatar': 'https://ui-avatars.com/api/?name=Nguyen+Van+A&background=random',
    'phone_number': '0987654321',
    'bio': 'Đây là thông tin giới thiệu của tôi.',
    'completion_percentage': 75,
    'created_at': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
    'updated_at': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
  };

  /// Giả lập endpoint GET /api/v1/profile
  Future<Map<String, dynamic>> getProfile() async {
    // Giả lập độ trễ mạng
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Giả lập có lỗi hoặc không (20% khả năng gặp lỗi)
    if (Random().nextInt(100) < 20) {
      throw Exception('Không thể kết nối đến máy chủ');
    }
    
    return _profile;
  }

  /// Giả lập endpoint PUT /api/v1/profile
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    // Giả lập độ trễ mạng
    await Future.delayed(const Duration(seconds: 1));
    
    // Cập nhật dữ liệu
    if (data.containsKey('name')) {
      _profile['name'] = data['name'];
    }
    
    if (data.containsKey('phone_number')) {
      _profile['phone_number'] = data['phone_number'];
    }
    
    if (data.containsKey('bio')) {
      _profile['bio'] = data['bio'];
    }
    
    if (data.containsKey('avatar')) {
      _profile['avatar'] = data['avatar'];
    }
    
    // Cập nhật thời gian
    _profile['updated_at'] = DateTime.now().toIso8601String();
    
    // Cập nhật completion_percentage dựa trên dữ liệu mới
    _updateCompletionPercentage();
    
    return _profile;
  }

  /// Giả lập việc tải ảnh lên server
  Future<String> uploadImage(File imageFile) async {
    // Giả lập độ trễ mạng
    await Future.delayed(const Duration(seconds: 1));
    
    // Giả lập URL ảnh được trả về từ server
    return 'https://ui-avatars.com/api/?name=${_profile['name']?.replaceAll(' ', '+')}&background=random&color=fff&size=200';
  }

  // Cập nhật phần trăm hoàn thành hồ sơ
  void _updateCompletionPercentage() {
    int completedFields = 0;
    int totalFields = 4; // name, email, phone_number, bio
    
    if (_profile['name'] != null && _profile['name'].toString().isNotEmpty) {
      completedFields++;
    }
    
    if (_profile['email'] != null && _profile['email'].toString().isNotEmpty) {
      completedFields++;
    }
    
    if (_profile['phone_number'] != null && _profile['phone_number'].toString().isNotEmpty) {
      completedFields++;
    }
    
    if (_profile['bio'] != null && _profile['bio'].toString().isNotEmpty) {
      completedFields++;
    }
    
    _profile['completion_percentage'] = (completedFields / totalFields * 100).round();
  }
} 