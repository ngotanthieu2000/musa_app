// TODO Implement this library.
abstract class AuthRepository {
  Future<void> login(String email, String password);
  Future<void> register(String email, String password);
  Future<void> logout();
  Future<bool> isAuthenticated();
}
