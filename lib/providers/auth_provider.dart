import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/data_service.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  AuthState _state = AuthState.initial;
  User? _user;
  String? _errorMessage;

  AuthState get state => _state;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;

  Future<bool> login(String email, String password) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    if (email.toLowerCase() == 'demo@brainbox.com' && password == 'password123') {
      _user = DataService.getMockUser();
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } else if (email.isNotEmpty && password.length >= 6) {
      _user = DataService.getMockUser().copyWith(
        email: email,
        name: email.split('@').first.replaceAll('.', ' ').split(' ').map((s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '').join(' '),
      );
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Invalid email or password. Please try again.';
      _state = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _user = null;
    _state = AuthState.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> updateProfile({
    String? name,
    bool? emailNotifications,
    bool? pushNotifications,
  }) async {
    if (_user == null) return false;

    await Future.delayed(const Duration(seconds: 1));

    _user = _user!.copyWith(
      name: name ?? _user!.name,
      emailNotifications: emailNotifications ?? _user!.emailNotifications,
      pushNotifications: pushNotifications ?? _user!.pushNotifications,
    );
    notifyListeners();
    return true;
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}