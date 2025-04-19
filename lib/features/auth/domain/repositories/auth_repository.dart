import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Kiểm tra đã xác thực hay chưa
  Future<Either<Failure, bool>> isAuthenticated();
  
  /// Lấy thông tin người dùng hiện tại
  Future<Either<Failure, User>> getCurrentUser();
  
  /// Đăng nhập với email và mật khẩu
  Future<Either<Failure, User>> login(String email, String password);
  
  /// Đăng ký với tên, email và mật khẩu
  Future<Either<Failure, User>> register(String name, String email, String password);
  
  /// Đăng xuất
  Future<Either<Failure, void>> logout();
  
  /// Quên mật khẩu
  Future<Either<Failure, void>> forgotPassword(String email);
  
  /// Cập nhật thông tin người dùng
  Future<Either<Failure, User>> updateProfile(User user);
  
  /// Thay đổi mật khẩu
  Future<Either<Failure, void>> changePassword(String oldPassword, String newPassword);
}
