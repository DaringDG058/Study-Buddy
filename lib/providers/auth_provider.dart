import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final SharedPreferences prefs;
  bool _isLoggedIn = false;
  String? _username;
  String? _password;

  AuthProvider(this.prefs) {
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (_isLoggedIn) {
      _username = prefs.getString('username');
      _password = prefs.getString('password');
    }
  }

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;
  String? get password => _password;

  Future<void> register(String username, String password) async {
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  Future<bool> login(String username, String password) async {
    final storedUser = prefs.getString('username');
    final storedPass = prefs.getString('password');

    if (username == storedUser && password == storedPass) {
      _isLoggedIn = true;
      _username = username;
      _password = password;
      await prefs.setBool('isLoggedIn', true);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> updateCredentials(String username, String password) async {
    _username = username;
    _password = password;
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _username = null;
    _password = null;
    await prefs.setBool('isLoggedIn', false);
    notifyListeners();
  }
}