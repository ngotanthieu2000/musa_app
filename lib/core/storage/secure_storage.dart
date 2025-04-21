import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Lớp bảo mật lưu trữ thông tin nhạy cảm
class SecureStorage {
  final FlutterSecureStorage storage;
  
  // Constants for token storage
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyExpiresAt = 'expires_at';
  
  /// Constructor
  SecureStorage({required this.storage});
  
  /// Lưu giá trị
  Future<void> write(String key, String value) async {
    await storage.write(key: key, value: value);
  }
  
  /// Đọc giá trị
  Future<String?> read(String key) async {
    return await storage.read(key: key);
  }
  
  /// Xóa giá trị
  Future<void> delete(String key) async {
    await storage.delete(key: key);
  }
  
  /// Xóa tất cả giá trị
  Future<void> deleteAll() async {
    await storage.deleteAll();
  }
  
  /// Kiểm tra key tồn tại
  Future<bool> containsKey(String key) async {
    return await storage.containsKey(key: key);
  }
  
  /// Lấy token truy cập
  Future<String?> getAccessToken() async {
    return await read(_keyAccessToken);
  }
  
  /// Lưu token truy cập
  Future<void> saveAccessToken(String token) async {
    return await write(_keyAccessToken, token);
  }
  
  /// Xóa token truy cập
  Future<void> deleteAccessToken() async {
    return await delete(_keyAccessToken);
  }
  
  /// Lấy token làm mới
  Future<String?> getRefreshToken() async {
    return await read(_keyRefreshToken);
  }
  
  /// Lưu token làm mới
  Future<void> saveRefreshToken(String token) async {
    return await write(_keyRefreshToken, token);
  }
  
  /// Xóa token làm mới
  Future<void> deleteRefreshToken() async {
    return await delete(_keyRefreshToken);
  }
  
  /// Lưu thời gian hết hạn
  Future<void> saveExpiresAt(DateTime expiresAt) async {
    return await write(
      _keyExpiresAt,
      expiresAt.millisecondsSinceEpoch.toString(),
    );
  }
  
  /// Lấy thời gian hết hạn
  Future<DateTime?> getExpiresAt() async {
    final expiresAtString = await read(_keyExpiresAt);
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
    await delete(_keyAccessToken);
    await delete(_keyRefreshToken);
    await delete(_keyExpiresAt);
  }
} 