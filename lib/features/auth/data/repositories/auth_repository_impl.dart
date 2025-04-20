import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/api_error_type.dart';
import '../../../../core/network';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final SecureStorage _secureStorage;
  
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyExpiresAt = 'expires_at';
  
  AuthRepositoryImpl({
    required ApiClient apiClient,
    required SecureStorage secureStorage,
  })  : _apiClient = apiClient,
        _secureStorage = secureStorage;
  
  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final registerResponse = await _apiClient.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'name': name ?? email.split('@').first,
        },
      );
      
      // Kiểm tra nếu đăng ký thành công nhưng không có thông tin token và user
      if (registerResponse is Map<String, dynamic> && 
          registerResponse.containsKey('message') && 
          registerResponse['message'] == 'Registration successful') {
        
        // Đăng ký thành công, thực hiện đăng nhập để lấy token và user info
        return login(email: email, password: password);
      }
      
      // Trường hợp response chứa cả token và user info
      if (registerResponse is Map<String, dynamic> && 
          registerResponse.containsKey('tokens') && 
          registerResponse.containsKey('user')) {
        
        // Save tokens
        final tokensModel = AuthTokensModel.fromJson(registerResponse['tokens']);
        await _saveTokens(tokensModel);
        
        // Set auth token for future requests
        _apiClient.setAuthToken(tokensModel.accessToken);
        
        // Return user
        final userModel = UserModel.fromJson(registerResponse['user']);
        return Right(userModel);
      }
      
      // Response không đúng định dạng
      return Left(ServerFailure(
        message: 'Invalid server response format',
        errorType: ApiErrorType.server
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message, 
        statusCode: e.statusCode,
        errorType: e.errorType,
        data: e.data
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(
        message: e.message,
        errorType: e.errorType,
        data: e.details
      ));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(
        message: e.message,
        errors: e.errors,
        data: e.details
      ));
    } catch (e) {
      return Left(UnexpectedFailure(
        message: e.toString(),
        data: e
      ));
    }
  }
  
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('Attempting login for: $email');
      final response = await _apiClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      print('Login response received: $response');
      
      // Extract tokens data
      Map<String, dynamic> tokensData;
      if (response is Map<String, dynamic>) {
        if (response.containsKey('tokens') && response['tokens'] is Map<String, dynamic>) {
          // Nested tokens structure
          tokensData = response['tokens'] as Map<String, dynamic>;
        } else if (response.containsKey('access_token') || response.containsKey('accessToken')) {
          // Flat structure
          tokensData = response;
        } else {
          print('Invalid response format. Missing tokens data.');
          return Left(ServerFailure(
            message: 'Invalid response format. Missing tokens data.',
            errorType: ApiErrorType.server
          ));
        }
      } else {
        print('Invalid response type: ${response.runtimeType}');
        return Left(ServerFailure(
          message: 'Invalid response type',
          errorType: ApiErrorType.server
        ));
      }
      
      print('Extracted tokens data: $tokensData');
      
      // Create tokensModel, handling both snake_case and camelCase keys
      final tokensModel = AuthTokensModel(
        accessToken: tokensData['access_token'] ?? tokensData['accessToken'] as String,
        refreshToken: tokensData['refresh_token'] ?? tokensData['refreshToken'] as String,
        expiresAt: tokensData['expires_at'] != null || tokensData['expiresAt'] != null 
          ? DateTime.parse(tokensData['expires_at'] ?? tokensData['expiresAt']) 
          : null,
      );
      
      await _saveTokens(tokensModel);
      
      // Set auth token for future requests
      _apiClient.setAuthToken(tokensModel.accessToken);
      
      // Check for user data and return it
      try {
        // If user data is in the response
        if (response.containsKey('user') && response['user'] is Map<String, dynamic>) {
          final userModel = UserModel.fromJson(response['user'] as Map<String, dynamic>);
          return Right(userModel);
        } 
        
        // If no user data, create a minimal user model with available info
        final userModel = UserModel(
          id: 'temp-id',  // We'll refresh this later from the /me endpoint
          email: email,
          name: email.split('@').first,
        );
        return Right(userModel);
      } catch (userError) {
        print('Error creating user model: $userError');
        // Return minimal user even if there's an error
        final userModel = UserModel(
          id: 'temp-id',
          email: email,
          name: email.split('@').first,
        );
        return Right(userModel);
      }
    } on ServerException catch (e) {
      print('ServerException during login: ${e.message}');
      return Left(ServerFailure(
        message: e.message, 
        statusCode: e.statusCode,
        errorType: e.errorType,
        data: e.data
      ));
    } on NetworkException catch (e) {
      print('NetworkException during login: ${e.message}');
      return Left(NetworkFailure(
        message: e.message,
        errorType: e.errorType,
        data: e.details
      ));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(
        message: e.message,
        errors: e.errors,
        data: e.details
      ));
    } on AuthException catch (e) {
      return Left(AuthFailure(
        message: e.message,
        errorType: e.errorType,
        data: e.details
      ));
    } catch (e) {
      print('Unexpected error during login: $e');
      return Left(UnexpectedFailure(
        message: e.toString(),
        data: e
      ));
    }
  }
  
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _apiClient.post('/auth/logout');
      
      // Clear tokens
      await _secureStorage.deleteAll();
      
      // Clear auth token
      _apiClient.clearAuthToken();
      
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message, 
        statusCode: e.statusCode,
        errorType: e.errorType,
        data: e.data
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(
        message: e.message,
        errorType: e.errorType,
        data: e.details
      ));
    } catch (e) {
      return Left(UnexpectedFailure(
        message: e.toString(),
        data: e
      ));
    }
  }
  
  @override
  Future<Either<Failure, AuthTokens>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/refresh',
        data: {
          'refresh_token': refreshToken,
        },
      );
      
      // Save tokens
      final tokensModel = AuthTokensModel.fromJson(response);
      await _saveTokens(tokensModel);
      
      // Set auth token for future requests
      _apiClient.setAuthToken(tokensModel.accessToken);
      
      return Right(tokensModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message, 
        statusCode: e.statusCode,
        errorType: e.errorType,
        data: e.data
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(
        message: e.message,
        errorType: e.errorType,
        data: e.details
      ));
    } on AuthException catch (e) {
      return Left(AuthFailure(
        message: e.message,
        errorType: e.errorType,
        data: e.details
      ));
    } catch (e) {
      return Left(UnexpectedFailure(
        message: e.toString(),
        data: e
      ));
    }
  }
  
  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // Check if we have a token
      final token = await _secureStorage.read(_keyAccessToken);
      if (token == null) {
        return Left(AuthFailure(
          message: 'User not authenticated',
          errorType: ApiErrorType.auth
        ));
      }
      
      // Set auth token
      _apiClient.setAuthToken(token);
      
      // Get user profile
      final response = await _apiClient.get('/auth/profile');
      
      final userModel = UserModel.fromJson(response['user']);
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message, 
        statusCode: e.statusCode,
        errorType: e.errorType,
        data: e.data
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(
        message: e.message,
        errorType: e.errorType,
        data: e.details
      ));
    } on AuthException catch (e) {
      return Left(AuthFailure(
        message: e.message,
        errorType: e.errorType,
        data: e.details
      ));
    } catch (e) {
      return Left(UnexpectedFailure(
        message: e.toString(),
        data: e
      ));
    }
  }
  
  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final token = await _secureStorage.read(_keyAccessToken);
      if (token == null) {
        return const Right(false);
      }
      
      final expiresAtString = await _secureStorage.read(_keyExpiresAt);
      if (expiresAtString == null) {
        return const Right(false);
      }
      
      final expiresAt = DateTime.parse(expiresAtString);
      if (expiresAt.isBefore(DateTime.now())) {
        // Token expired, try to refresh
        final refreshToken = await _secureStorage.read(_keyRefreshToken);
        if (refreshToken == null) {
          return const Right(false);
        }
        
        final refreshResult = await this.refreshToken(refreshToken: refreshToken);
        return refreshResult.fold(
          (_) => const Right(false),
          (_) => const Right(true),
        );
      }
      
      return const Right(true);
    } catch (e) {
      return const Right(false);
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
