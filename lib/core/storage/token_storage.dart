import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Lớp lưu trữ token xác thực
class TokenStorage {
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyExpiresAt = 'expires_at';
  
  final FlutterSecureStorage secureStorage;
  
  /// Constructor
  TokenStorage({required this.secureStorage});
  
  /// Lấy token truy cập
  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: _keyAccessToken);
  }
  
  /// Lưu token truy cập
  Future<void> saveAccessToken(String token) async {
    return await secureStorage.write(key: _keyAccessToken, value: token);
  }
  
  /// Lấy token làm mới
  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: _keyRefreshToken);
  }
  
  /// Lưu token làm mới
  Future<void> saveRefreshToken(String token) async {
    return await secureStorage.write(key: _keyRefreshToken, value: token);
  }
  
  /// Lưu thời gian hết hạn
  Future<void> saveExpiresAt(DateTime expiresAt) async {
    return await secureStorage.write(
      key: _keyExpiresAt,
      value: expiresAt.millisecondsSinceEpoch.toString(),
    );
  }
  
  /// Lấy thời gian hết hạn
  Future<DateTime?> getExpiresAt() async {
    final expiresAtString = await secureStorage.read(key: _keyExpiresAt);
    if (expiresAtString == null) return null;
    
    final expiresAtMillis = int.tryParse(expiresAtString);
    if (expiresAtMillis == null) return null;
    
    return DateTime.fromMillisecondsSinceEpoch(expiresAtMillis);
  }
  
  /// Kiểm tra token có hết hạn chưa
  Future<bool> isTokenExpired() async {
    final expiresAt = await getExpiresAt();
    if (expiresAt == null) return true;
    
    return DateTime.now().isAfter(expiresAt);
  }
  
  /// Lưu tất cả token
  Future<void> saveAllTokens({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
  }) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
    await saveExpiresAt(expiresAt);
  }
  
  /// Xóa tất cả token
  Future<void> clearAllTokens() async {
    await secureStorage.delete(key: _keyAccessToken);
    await secureStorage.delete(key: _keyRefreshToken);
    await secureStorage.delete(key: _keyExpiresAt);
  }
  
  /// Gắn token vào header xác thực
  Future<Map<String, String>> getAuthHeader() async {
    final token = await getAccessToken();
    if (token == null) return {};
    
    return {'Authorization': 'Bearer $token'};
  }
} 