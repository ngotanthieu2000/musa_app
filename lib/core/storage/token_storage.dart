import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _secureStorage;
  
  // Keys for secure storage
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userEmailKey = 'user_email';
  
  TokenStorage({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();
  
  // Save access token
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
  }
  
  // Get access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }
  
  // Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }
  
  // Get refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }
  
  // Save user email
  Future<void> saveUserEmail(String email) async {
    await _secureStorage.write(key: _userEmailKey, value: email);
  }
  
  // Get user email
  Future<String?> getUserEmail() async {
    return await _secureStorage.read(key: _userEmailKey);
  }
  
  // Clear all tokens (when logging out)
  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
  
  // Save all authentication data
  Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
    required String email,
  }) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
    await saveUserEmail(email);
  }
  
  // Clear all authentication data
  Future<void> clearAuthData() async {
    await clearTokens();
    await _secureStorage.delete(key: _userEmailKey);
  }
} 