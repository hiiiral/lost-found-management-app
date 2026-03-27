import '../models/user_model.dart';

/// User repository for managing user data operations
class UserRepository {
  // Singleton instance
  static final UserRepository _instance = UserRepository._internal();

  factory UserRepository() {
    return _instance;
  }

  UserRepository._internal();

  // Mock user storage
  final Map<String, UserModel> _users = {};

  /// Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));
      return _users[userId];
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  /// Update user profile
  Future<UserModel?> updateUser(UserModel user) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 400));
      _users[user.id] = user;
      return user;
    } catch (e) {
      print('Error updating user: $e');
      return null;
    }
  }

  /// Save user to local storage
  void saveUserLocally(UserModel user) {
    _users[user.id] = user;
  }

  /// Check if user exists
  bool userExists(String userId) {
    return _users.containsKey(userId);
  }

  /// Get all users (for admin purposes)
  List<UserModel> getAllUsers() {
    return _users.values.toList();
  }
}
