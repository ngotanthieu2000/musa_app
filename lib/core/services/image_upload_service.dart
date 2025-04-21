import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:injectable/injectable.dart';

// Import sử dụng barrel files hoặc import tương đối
import '../error/exceptions.dart';
import '../error/api_error_type.dart';
import '../network_helper.dart';

/// Service xử lý việc tải ảnh lên server
@lazySingleton
class ImageUploadService {
  final ApiClient _apiClient;
  
  /// Constructor
  ImageUploadService({required ApiClient apiClient}) : _apiClient = apiClient;
  
  /// Tải ảnh lên server và trả về URL của ảnh đã tải
  Future<String> uploadImage(File imageFile, {String? folder = 'avatars'}) async {
    try {
      // Tạo body cho request
      final String fileName = path.basename(imageFile.path);
      final String mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      
      // Tạo FormData
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
        'folder': folder,
      });
      
      // Gửi request
      final response = await _apiClient.dio.post(
        '/api/v1/upload/image',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      // Xử lý response
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['url'] != null) {
          return response.data['url'] as String;
        }
      }
      
      throw ServerException(
        message: 'Không thể tải ảnh lên: ${response.statusMessage}',
        errorType: ApiErrorType.server,
      );
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      
      throw ServerException(
        message: 'Lỗi khi tải ảnh lên: ${e.toString()}',
        errorType: ApiErrorType.server,
      );
    }
  }
} 