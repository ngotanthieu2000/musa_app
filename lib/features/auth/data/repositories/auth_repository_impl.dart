import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final http.Client httpClient;

  AuthRepositoryImpl({http.Client? client})
      : httpClient = client ?? http.Client();

  static const String baseUrl =
      'https://your-api.com/api'; // thay bằng domain thật

  @override
  Future<void> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await httpClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Parse token hoặc dữ liệu user nếu cần
        final data = jsonDecode(response.body);
        print('Đăng nhập thành công: $data');
        // TODO: Lưu token vào local storage (shared_preferences hoặc secure storage)
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Đăng nhập thất bại');
      }
    } catch (e) {
      print('Lỗi login: $e');
      throw Exception('Không thể đăng nhập: $e');
    }
  }

  @override
  Future<void> register(String email, String password) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      final response = await httpClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Đăng ký thành công: $data');
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Đăng ký thất bại');
      }
    } catch (e) {
      print('Lỗi register: $e');
      throw Exception('Không thể đăng ký: $e');
    }
  }

  @override
  Future<void> logout() async {
    final url = Uri.parse('$baseUrl/logout');
    try {
      final response = await httpClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        // Nếu có Bearer Token thì gắn ở headers Authorization
      );

      if (response.statusCode == 200) {
        print('Đăng xuất thành công');
        // TODO: Xoá token ở local storage nếu có
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Đăng xuất thất bại');
      }
    } catch (e) {
      print('Lỗi logout: $e');
      throw Exception('Không thể đăng xuất: $e');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final url = Uri.parse('$baseUrl/is-authenticated');
    try {
      final response = await httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          // TODO: Gắn token vào Authorization header nếu cần
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isAuthenticated'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print('Lỗi kiểm tra xác thực: $e');
      return false;
    }
  }
}
