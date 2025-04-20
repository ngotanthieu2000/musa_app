import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_tokens.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Đăng ký người dùng mới
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    String? name,
  });
  
  /// Đăng nhập người dùng
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });
  
  /// Làm mới token
  Future<Either<Failure, AuthTokens>> refreshToken({
    required String refreshToken,
  });
  
  /// Đăng xuất người dùng
  Future<Either<Failure, void>> logout();
  
  /// Lấy thông tin người dùng hiện tại
  Future<Either<Failure, User>> getCurrentUser();
  
  /// Kiểm tra xem người dùng đã đăng nhập chưa
  Future<Either<Failure, bool>> isLoggedIn();
}
