import 'dart:convert';
import 'dart:io' if (dart.library.js) 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:musa_app/config/env_config.dart';
import 'package:musa_app/features/auth/data/models/user_model.dart';
import 'error/exceptions.dart';
import 'error/api_error_type.dart';
import 'storage/secure_storage.dart';

/// API client for handling network requests with Dio
class ApiClient {
  final Dio dio;
  final String baseUrl;
  final SecureStorage secureStorage;
  bool _isRefreshing = false;
  
  ApiClient({
    required this.baseUrl,
    required this.dio,
    required this.secureStorage,
  }) {
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.validateStatus = (status) {
      return status != null && status < 500;
    };

    // Add logging for debug mode
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
    
    // Add token refresh interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        // Nếu lỗi 401 và không phải đang refresh token
        if (error.response?.statusCode == 401 &&
            !_isRefreshing &&
            error.requestOptions.path != '/api/v1/auth/refresh') {
          _isRefreshing = true;
          try {
            // Lấy refresh token từ storage
            final refreshToken = await secureStorage.getRefreshToken();
            if (refreshToken != null && refreshToken.isNotEmpty) {
              // Gọi API refresh token
              final response = await dio.post(
                '/api/v1/auth/refresh',
                data: {'refresh_token': refreshToken},
              );
              
              if (response.statusCode == 200 && response.data != null) {
                // Lưu token mới
                final newAccessToken = response.data['access_token'];
                final newRefreshToken = response.data['refresh_token'];
                
                if (newAccessToken != null) {
                  await secureStorage.saveAccessToken(newAccessToken);
                  setAuthToken(newAccessToken);
                }
                
                if (newRefreshToken != null) {
                  await secureStorage.saveRefreshToken(newRefreshToken);
                }
                
                // Retry request với token mới
                final opts = Options(
                  method: error.requestOptions.method,
                  headers: {
                    'Authorization': 'Bearer $newAccessToken',
                    ...error.requestOptions.headers
                  },
                );
                
                final newResponse = await dio.request(
                  error.requestOptions.path,
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                  options: opts,
                );
                
                _isRefreshing = false;
                return handler.resolve(newResponse);
              }
            }
          } catch (e) {
            print('Lỗi khi refresh token: $e');
          }
          _isRefreshing = false;
        }
        return handler.next(error);
      }
    ));
  }

  /// Set authorization token for requests
  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }
  
  /// Clear authorization token
  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }
  
  /// Get current user from API
  Future<UserModel> getCurrentUser() async {
    final response = await get('/api/auth/me');
    return UserModel.fromJson(response['data']);
  }

  /// Get request with error handling
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw ServerException(
        message: 'Lỗi không xác định: ${e.toString()}',
        errorType: ApiErrorType.unknown,
        details: e.toString(),
      );
    }
  }

  /// Post request with error handling
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw ServerException(
        message: 'Lỗi không xác định: ${e.toString()}',
        errorType: ApiErrorType.unknown,
        details: e.toString(),
      );
    }
  }

  /// Put request with error handling
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw ServerException(
        message: 'Lỗi không xác định: ${e.toString()}',
        errorType: ApiErrorType.unknown,
        details: e.toString(),
      );
    }
  }

  /// Delete request with error handling
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw ServerException(
        message: 'Lỗi không xác định: ${e.toString()}',
        errorType: ApiErrorType.unknown,
        details: e.toString(),
      );
    }
  }

  /// Handle API response based on status code
  dynamic _handleResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data;
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Server error with status code: ${response.statusCode}',
      );
    }
  }

  /// Handle Dio errors and convert to appropriate exceptions
  Exception _handleError(DioException e) {
    ApiErrorType errorType = ApiErrorType.unknown;
    String errorMessage = 'Đã xảy ra lỗi không xác định';
    
    if (e.response != null) {
      final statusCode = e.response!.statusCode ?? 0;
      
      if (statusCode == 400) {
        errorType = ApiErrorType.validation;
      } else if (statusCode == 401 || statusCode == 403) {
        errorType = ApiErrorType.auth;
      } else if (statusCode == 404) {
        errorType = ApiErrorType.notFound;
      } else if (statusCode >= 500) {
        errorType = ApiErrorType.server;
      }
      
      var data = e.response!.data;
      if (data is Map<String, dynamic>) {
        errorMessage = data['message'] ?? data['error'] ?? errorMessage;
      }
      
      return ServerException(
        message: errorMessage,
        errorType: errorType,
        data: e.response?.data,
      );
    } else if (e.type == DioExceptionType.connectionTimeout ||
               e.type == DioExceptionType.receiveTimeout ||
               e.type == DioExceptionType.sendTimeout) {
      errorType = ApiErrorType.timeout;
      errorMessage = 'Yêu cầu đã hết thời gian. Vui lòng thử lại.';
    } else if (e.type == DioExceptionType.connectionError) {
      errorType = ApiErrorType.network;
      errorMessage = 'Không có kết nối mạng. Vui lòng kiểm tra kết nối.';
    }
    
    if (errorType == ApiErrorType.network) {
      return NetworkException(
        message: errorMessage,
        errorType: errorType,
      );
    } else {
      return ServerException(
        message: errorMessage,
        errorType: errorType,
      );
    }
  }
} 