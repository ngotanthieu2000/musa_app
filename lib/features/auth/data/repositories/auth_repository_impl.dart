import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/api_error_type.dart';
import '../../../../core/network_helper.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final SecureStorage _secureStorage;
  final AuthRemoteDataSource _remoteDataSource;
  
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyExpiresAt = 'expires_at';
  
  AuthRepositoryImpl({
    required ApiClient apiClient,
    required SecureStorage secureStorage,
    required AuthRemoteDataSource remoteDataSource,
  })  : _apiClient = apiClient,
        _secureStorage = secureStorage,
        _remoteDataSource = remoteDataSource;
  
  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final response = await _remoteDataSource.register(name ?? email.split('@').first, email, password);
      
      if (response.user != null) {
        return Right(response.user!);
      } else {
        return Left(ServerFailure(
          message: 'User data is missing from the response',
          errorType: ApiErrorType.unknown,
        ));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        errorType: e.errorType,
        data: e.data,
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        errorType: ApiErrorType.unknown,
      ));
    }
  }
  
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('AuthRepositoryImpl: Calling login with email: $email');
      final tokens = await _remoteDataSource.login(email, password);
      
      print('AuthRepositoryImpl: Received tokens response: $tokens');
      
      // Kiểm tra access token và save nếu có
      if (tokens.accessToken != null && tokens.accessToken!.isNotEmpty) {
        print('AuthRepositoryImpl: Saving access token');
        await _secureStorage.saveAccessToken(tokens.accessToken!);
        _apiClient.setAuthToken(tokens.accessToken!);
      } else {
        print('AuthRepositoryImpl: No valid access token received');
        return Left(ServerFailure(
          message: 'Không nhận được access token hợp lệ',
          errorType: ApiErrorType.auth,
        ));
      }
      
      // Kiểm tra refresh token và save nếu có
      if (tokens.refreshToken != null && tokens.refreshToken!.isNotEmpty) {
        print('AuthRepositoryImpl: Saving refresh token');
        await _secureStorage.saveRefreshToken(tokens.refreshToken!);
      } else {
        print('AuthRepositoryImpl: No valid refresh token received, but continuing');
      }
      
      // Kiểm tra user và return nếu có
      if (tokens.user != null) {
        print('AuthRepositoryImpl: User data received: ${tokens.user}');
        return Right(tokens.user!);
      } 
      
      // Nếu không có user data, lấy user từ API
      print('AuthRepositoryImpl: No user data, fetching from API');
      try {
        final user = await _remoteDataSource.getCurrentUser();
        return Right(user);
      } catch (e) {
        print('AuthRepositoryImpl: Error fetching user data: $e');
        // Vẫn trả về thành công nếu chúng ta ít nhất có token
        return Right(User(
          id: '0',
          email: email,
          name: email.split('@').first,
        ));
      }
    } on ServerException catch (e) {
      print('AuthRepositoryImpl: Server exception: ${e.message}');
      return Left(ServerFailure(
        message: e.message,
        errorType: e.errorType,
        data: e.data,
      ));
    } catch (e) {
      print('AuthRepositoryImpl: Unexpected error: $e');
      return Left(ServerFailure(
        message: e.toString(),
        errorType: ApiErrorType.unknown,
      ));
    }
  }
  
  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await _remoteDataSource.logout();
      
      // Clear tokens
      await _secureStorage.delete(_keyAccessToken);
      await _secureStorage.delete(_keyRefreshToken);
      
      // Clear the token from API client
      _apiClient.clearAuthToken();
      
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        errorType: e.errorType,
        data: e.data,
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        errorType: ApiErrorType.unknown,
      ));
    }
  }
  
  @override
  Future<Either<Failure, AuthTokens>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      print('AuthRepository: Attempting to refresh token');
      
      // Kiểm tra refreshToken truyền vào
      if (refreshToken.isEmpty) {
        // Nếu không có, thử lấy từ storage
        final currentRefreshToken = await _secureStorage.getRefreshToken();
        
        if (currentRefreshToken == null || currentRefreshToken.isEmpty) {
          print('AuthRepository: No refresh token available');
          return Left(AuthFailure(
            message: 'Không có refresh token',
            errorType: ApiErrorType.auth,
          ));
        }
        
        // Sử dụng token từ storage
        refreshToken = currentRefreshToken;
      }
      
      print('AuthRepository: Calling refresh token API');
      final tokens = await _remoteDataSource.refreshToken(refreshToken);
      
      // Lưu token mới
      if (tokens.accessToken != null && tokens.accessToken!.isNotEmpty) {
        print('AuthRepository: Saving new access token');
        await _secureStorage.saveAccessToken(tokens.accessToken!);
        _apiClient.setAuthToken(tokens.accessToken!);
      } else {
        print('AuthRepository: No valid access token in response');
        return Left(AuthFailure(
          message: 'Không nhận được access token hợp lệ',
          errorType: ApiErrorType.auth,
        ));
      }
      
      // Lưu refresh token mới nếu có
      if (tokens.refreshToken != null && tokens.refreshToken!.isNotEmpty) {
        print('AuthRepository: Saving new refresh token');
        await _secureStorage.saveRefreshToken(tokens.refreshToken!);
      }
      
      return Right(AuthTokens(
        accessToken: tokens.accessToken ?? '',
        refreshToken: tokens.refreshToken ?? '',
        expiresAt: tokens.expiresAt,
      ));
    } on ServerException catch (e) {
      print('AuthRepository: Server exception during refresh: ${e.message}');
      return Left(ServerFailure(
        message: e.message,
        errorType: e.errorType,
        data: e.data,
      ));
    } catch (e) {
      print('AuthRepository: Unexpected error during refresh: $e');
      return Left(ServerFailure(
        message: e.toString(),
        errorType: ApiErrorType.unknown,
      ));
    }
  }
  
  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        errorType: e.errorType,
        data: e.data,
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        errorType: ApiErrorType.unknown,
      ));
    }
  }
  
  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final token = await _secureStorage.getAccessToken();
      return Right(token != null && token.isNotEmpty);
    } catch (e) {
      return Left(AuthFailure(
        message: 'Không thể kiểm tra trạng thái đăng nhập',
        errorType: ApiErrorType.auth,
      ));
    }
  }
  
  @override
  Future<Either<Failure, User>> refreshCurrentUser() async {
    try {
      // Get current user from API
      final userResponse = await _remoteDataSource.getCurrentUser();
      
      // Update auth token for future requests
      final token = await _secureStorage.getAccessToken();
      if (token != null) {
        _apiClient.setAuthToken(token);
      }
      
      return Right(userResponse);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message, 
        errorType: e.errorType,
        data: e.data
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Lỗi lấy thông tin người dùng: ${e.toString()}',
        errorType: ApiErrorType.server,
      ));
    }
  }
  
  // Helper method to save tokens to secure storage
  Future<void> _saveTokens(AuthTokensModel tokens) async {
    await _secureStorage.write(_keyAccessToken, tokens.accessToken);
    await _secureStorage.write(_keyRefreshToken, tokens.refreshToken);
    
    if (tokens.expiresAt != null) {
      await _secureStorage.write(_keyExpiresAt, tokens.expiresAt!.toIso8601String());
    } else {
      // Nếu expiresAt là null, tạo thời gian hết hạn mặc định là 1 giờ từ hiện tại
      final defaultExpiry = DateTime.now().add(const Duration(hours: 1));
      await _secureStorage.write(_keyExpiresAt, defaultExpiry.toIso8601String());
    }
  }
}
