import '../storage/secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final SecureStorage _secureStorage;

  // For testing purposes, we'll use a mock token
  static const String _mockToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyMTIzIiwibmFtZSI6IkFsZXggSm9obnNvbiIsImlhdCI6MTUxNjIzOTAyMn0.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';

  // For testing with the local API
  static const String _localApiToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1ZjJlMzA0ZTI5MDRkNzRhZGRkMDVlZCIsImVtYWlsIjoiYWxleEBleGFtcGxlLmNvbSIsImlhdCI6MTcxMDQxMDUwMCwiZXhwIjoxNzEwNDk2OTAwfQ.Wy3GwmOsxXv4Ggj3NtS9AGN5ygQcMjNk-HrKRGXiBDM';

  static const String _userIdKey = 'user_id';

  AuthService({SecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? SecureStorage(storage: const FlutterSecureStorage());

  Future<String?> getToken() async {
    // Use the actual token from secure storage
    return await _secureStorage.getAccessToken();
  }

  Future<String> getAccessToken() async {
    final token = await getToken();
    print('AuthService.getAccessToken: token = $token');

    // If no token is found, use the local API token for testing
    // This token should work with the local API
    return token ?? _localApiToken;
  }

  Future<void> saveToken(String token) async {
    await _secureStorage.saveAccessToken(token);
  }

  Future<void> deleteToken() async {
    await _secureStorage.deleteAccessToken();
  }

  Future<String?> getUserId() async {
    return await _secureStorage.read(_userIdKey);
  }

  Future<void> saveUserId(String userId) async {
    await _secureStorage.write(_userIdKey, userId);
  }

  Future<void> deleteUserId() async {
    await _secureStorage.delete(_userIdKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await deleteToken();
    await deleteUserId();
  }
}
