import '../models/user_model.dart';

/// Authentication service for user authentication operations
class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // Mock current user
  UserModel? _currentUser;

  /// Get current logged-in user
  UserModel? get currentUser => _currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => _currentUser != null;

  /// Login with email and password
  Future<UserModel?> loginWithEmail(String email, String password) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 900));

      // Mock login success
      _currentUser = UserModel(
        id: '1',
        name: 'User',
        email: email,
        createdAt: DateTime.now(),
      );

      return _currentUser;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  /// Register new user
  Future<UserModel?> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 900));

      // Mock registration success
      _currentUser = UserModel(
        id: '1',
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );

      return _currentUser;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      _currentUser = null;
    } catch (e) {
      print('Logout error: $e');
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1200));
      return true;
    } catch (e) {
      print('Password reset error: $e');
      return false;
    }
  }
}
