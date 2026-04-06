import 'dart:convert';

import 'package:parking/data/user_repository.dart';
import 'package:parking/models/user.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LocalUserRepository implements UserRepository {
  static const _usersKey = 'sp_users';
  static const _sessionKey = 'sp_session';

  Future<Map<String, dynamic>> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null) return {};
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> _saveUsers(Map<String, dynamic> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  @override
  Future<bool> register(User user) async {
    final users = await _loadUsers();
    if (users.containsKey(user.email)) return false;
    users[user.email] = user.toJson();
    await _saveUsers(users);
    return true;
  }

  @override
  Future<User?> login(String email, String password) async {
    final users = await _loadUsers();
    final data = users[email];
    if (data == null) return null;
    final user = User.fromJson(data as Map<String, dynamic>);
    return user.password == password ? user : null;
  }

  @override
  Future<User?> getUser(String email) async {
    final users = await _loadUsers();
    final data = users[email];
    if (data == null) return null;
    return User.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> updateUser(User user) async {
    final users = await _loadUsers();
    users[user.email] = user.toJson();
    await _saveUsers(users);
  }

  @override
  Future<void> deleteUser(String email) async {
    final users = await _loadUsers();
    users.remove(email);
    await _saveUsers(users);
    await clearSession();
  }

  @override
  Future<void> saveSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, email);
  }

  @override
  Future<String?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey);
  }

  @override
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
