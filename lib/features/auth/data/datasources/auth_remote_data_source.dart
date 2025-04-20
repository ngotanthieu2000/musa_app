import '../../../../core/network';
import '../../../../core/error/exceptions.dart';
import '../models/auth_request_models.dart';
import '../models/auth_response_models.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Register new user
  Future<AuthResponse> register(String name, String email, String password);
  
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
  Future<AuthResponse> register(String name, String email, String password) async {
    try {
      final response = await apiClient.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      
      return AuthResponse.fromJson(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      print('AuthRemoteDataSource: Attempting login for: $email');
      final response = await apiClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      print('AuthRemoteDataSource: Raw login response: $response');
      
      // Add default success field if missing
      Map<String, dynamic> processedResponse;
      if (response is Map<String, dynamic>) {
        processedResponse = Map<String, dynamic>.from(response);
        if (!processedResponse.containsKey('success')) {
          processedResponse['success'] = true;
        }
      } else {
        print('AuthRemoteDataSource: Invalid response type: ${response.runtimeType}');
        throw ServerException(message: 'Invalid response format');
      }
      
      print('AuthRemoteDataSource: Processed response for AuthResponse: $processedResponse');
      
      try {
        final authResponse = AuthResponse.fromJson(processedResponse);
        print('AuthRemoteDataSource: Successfully parsed AuthResponse: $authResponse');
        return authResponse;
      } catch (parseError) {
        print('AuthRemoteDataSource: Error parsing response: $parseError');
        
        // Create a fallback response with the raw tokens
        var fallbackResponse = AuthResponse(
          success: true,
          accessToken: processedResponse['access_token'] ?? 
                      (processedResponse['tokens'] is Map ? 
                       processedResponse['tokens']['access_token'] : null),
          refreshToken: processedResponse['refresh_token'] ?? 
                       (processedResponse['tokens'] is Map ? 
                        processedResponse['tokens']['refresh_token'] : null),
          user: processedResponse['user'] is Map ? 
                UserModel.fromJson(processedResponse['user']) : null,
        );
        
        print('AuthRemoteDataSource: Created fallback response: $fallbackResponse');
        return fallbackResponse;
      }
    } catch (e) {
      print('AuthRemoteDataSource: Login error: $e');
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await apiClient.post(
        '/auth/refresh',
        data: {
          'refreshToken': refreshToken,
        },
      );
      
      return AuthResponse.fromJson(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<void> logout() async {
    try {
      await apiClient.post('/auth/logout');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.get('/auth/me');
      return UserModel.fromJson(response['user']);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
} 