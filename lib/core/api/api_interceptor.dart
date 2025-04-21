import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

/// Interceptor xử lý token tự động
class TokenInterceptor extends Interceptor {
  final SecureStorage secureStorage;
  final AuthRepository authRepository;
  final Dio dio;
  bool _isRefreshing = false;
  final _refreshCompleter = Completer<bool>();
  
  TokenInterceptor({
    required this.secureStorage,
    required this.authRepository,
    required this.dio,
  });
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Thêm token vào header nếu có
    final token = await secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Nếu lỗi không phải 401 hoặc là request refresh token, bỏ qua
    if (err.response?.statusCode != 401 || 
        err.requestOptions.path.contains('/api/v1/auth/refresh')) {
      return handler.next(err);
    }
    
    if (_isRefreshing) {
      // Đợi quá trình refresh hoàn tất
      final success = await _refreshCompleter.future;
      if (success) {
        // Thử lại request ban đầu
        try {
          final token = await secureStorage.getAccessToken();
          final opts = Options(
            method: err.requestOptions.method,
            headers: {...err.requestOptions.headers, 'Authorization': 'Bearer $token'},
          );
          
          final response = await dio.request(
            err.requestOptions.path,
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
            options: opts,
          );
          
          return handler.resolve(response);
        } catch (e) {
          if (kDebugMode) {
            print('TokenInterceptor: Error retrying request: $e');
          }
          return handler.next(err);
        }
      } else {
        // Nếu refresh thất bại, trả về lỗi ban đầu
        return handler.next(err);
      }
    }
    
    // Bắt đầu refresh token
    _isRefreshing = true;
    
    try {
      final refreshToken = await secureStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        _isRefreshing = false;
        _refreshCompleter.complete(false);
        _refreshCompleter.future; // Reset completer
        return handler.next(err);
      }
      
      // Gọi API refresh token
      final result = await authRepository.refreshToken(refreshToken: refreshToken);
      
      result.fold(
        (failure) {
          // Refresh thất bại
          if (kDebugMode) {
            print('TokenInterceptor: Token refresh failed: ${failure.message}');
          }
          _isRefreshing = false;
          _refreshCompleter.complete(false);
          return handler.next(err);
        },
        (tokens) async {
          // Refresh thành công
          if (kDebugMode) {
            print('TokenInterceptor: Token refreshed successfully');
          }
          
          // Thử lại request ban đầu
          try {
            final opts = Options(
              method: err.requestOptions.method,
              headers: {...err.requestOptions.headers, 'Authorization': 'Bearer ${tokens.accessToken}'},
            );
            
            final response = await dio.request(
              err.requestOptions.path,
              data: err.requestOptions.data,
              queryParameters: err.requestOptions.queryParameters,
              options: opts,
            );
            
            _isRefreshing = false;
            _refreshCompleter.complete(true);
            return handler.resolve(response);
          } catch (e) {
            if (kDebugMode) {
              print('TokenInterceptor: Error retrying request after refresh: $e');
            }
            _isRefreshing = false;
            _refreshCompleter.complete(false);
            return handler.next(err);
          }
        }
      );
    } catch (e) {
      if (kDebugMode) {
        print('TokenInterceptor: Unexpected error during refresh: $e');
      }
      _isRefreshing = false;
      _refreshCompleter.complete(false);
      return handler.next(err);
    }
  }
} 