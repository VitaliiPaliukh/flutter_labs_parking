import 'package:parking/models/user.dart';

abstract class UserRepository {
  Future<bool> register(User user);
  Future<User?> login(String email, String password);
  Future<User?> getUser(String email);
  Future<void> updateUser(User user);
  Future<void> deleteUser(String email);
  Future<void> saveSession(String email);
  Future<String?> getSession();
  Future<void> clearSession();
}
