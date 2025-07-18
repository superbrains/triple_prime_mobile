import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:triple_prime_mobile/core/constants/app_constants.dart';
import 'package:triple_prime_mobile/shared/models/auth_models.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;

  final _storage = const FlutterSecureStorage();
  final _logger = Logger();

  StorageService._internal();

  // MARK: - Auth Token Methods

  /// Save authentication token to secure storage
  Future<void> saveAuthToken(String token) async {
    try {
      await _storage.write(key: AppConstants.tokenKey, value: token);
      _logger.i('🔐 Auth token saved to secure storage');
    } catch (e) {
      _logger.e('💥 Failed to save auth token: $e');
      rethrow;
    }
  }

  /// Get authentication token from secure storage
  Future<String?> getAuthToken() async {
    try {
      final token = await _storage.read(key: AppConstants.tokenKey);
      return token;
    } catch (e) {
      _logger.e('💥 Failed to get auth token: $e');
      return null;
    }
  }

  /// Clear authentication token from secure storage
  Future<void> clearAuthToken() async {
    try {
      await _storage.delete(key: AppConstants.tokenKey);
      _logger.i('🔐 Auth token cleared from secure storage');
    } catch (e) {
      _logger.e('💥 Failed to clear auth token: $e');
      rethrow;
    }
  }

  // MARK: - User Data Methods

  /// Save user data to secure storage
  Future<void> saveUserData(UserData userData) async {
    try {
      final userDataJson = userData.toJson();
      final userDataString = jsonEncode(userDataJson);
      await _storage.write(key: AppConstants.userKey, value: userDataString);
      _logger.i('💾 User data saved to secure storage');
    } catch (e) {
      _logger.e('💥 Failed to save user data: $e');
      rethrow;
    }
  }

  /// Get user data from secure storage
  Future<UserData?> getUserData() async {
    try {
      final userDataString = await _storage.read(key: AppConstants.userKey);
      if (userDataString != null && userDataString.isNotEmpty) {
        final userDataMap = jsonDecode(userDataString) as Map<String, dynamic>;
        final userData = UserData.fromJson(userDataMap);
        _logger.i('📱 User data retrieved from secure storage');
        return userData;
      }
      return null;
    } catch (e) {
      _logger.e('💥 Failed to get user data: $e');
      return null;
    }
  }

  /// Clear user data from secure storage
  Future<void> clearUserData() async {
    try {
      await _storage.delete(key: AppConstants.userKey);
      _logger.i('💾 User data cleared from secure storage');
    } catch (e) {
      _logger.e('💥 Failed to clear user data: $e');
      rethrow;
    }
  }

  // MARK: - Authentication State Methods

  /// Check if user is authenticated (has both token and user data)
  Future<bool> isAuthenticated() async {
    try {
      final token = await getAuthToken();
      final userData = await getUserData();

      final isAuth = token != null && token.isNotEmpty && userData != null;

      _logger.i(
          '🔍 Authentication check: ${isAuth ? 'Authenticated' : 'Not authenticated'}');
      return isAuth;
    } catch (e) {
      _logger.e('💥 Authentication check error: $e');
      return false;
    }
  }

  /// Clear all authentication data (token + user data)
  Future<void> clearAllAuthData() async {
    try {
      await Future.wait([
        clearAuthToken(),
        clearUserData(),
      ]);
      _logger.i('🧹 All authentication data cleared');
    } catch (e) {
      _logger.e('💥 Failed to clear all auth data: $e');
      rethrow;
    }
  }

  // MARK: - Theme Methods

  /// Save app theme preference
  Future<void> saveTheme(String theme) async {
    try {
      await _storage.write(key: AppConstants.themeKey, value: theme);
      _logger.i('🎨 Theme preference saved: $theme');
    } catch (e) {
      _logger.e('💥 Failed to save theme: $e');
      rethrow;
    }
  }

  /// Get app theme preference
  Future<String?> getTheme() async {
    try {
      final theme = await _storage.read(key: AppConstants.themeKey);
      return theme;
    } catch (e) {
      _logger.e('💥 Failed to get theme: $e');
      return null;
    }
  }

  /// Clear app theme preference
  Future<void> clearTheme() async {
    try {
      await _storage.delete(key: AppConstants.themeKey);
      _logger.i('🎨 Theme preference cleared');
    } catch (e) {
      _logger.e('💥 Failed to clear theme: $e');
      rethrow;
    }
  }

  // MARK: - Generic Storage Methods

  /// Save any data with a custom key
  Future<void> saveData(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      _logger.i('💾 Data saved with key: $key');
    } catch (e) {
      _logger.e('💥 Failed to save data with key $key: $e');
      rethrow;
    }
  }

  /// Get data with a custom key
  Future<String?> getData(String key) async {
    try {
      final data = await _storage.read(key: key);
      return data;
    } catch (e) {
      _logger.e('💥 Failed to get data with key $key: $e');
      return null;
    }
  }

  /// Delete data with a custom key
  Future<void> deleteData(String key) async {
    try {
      await _storage.delete(key: key);
      _logger.i('🗑️ Data deleted with key: $key');
    } catch (e) {
      _logger.e('💥 Failed to delete data with key $key: $e');
      rethrow;
    }
  }

  /// Clear all stored data
  Future<void> clearAllData() async {
    try {
      await _storage.deleteAll();
      _logger.i('🧹 All data cleared from secure storage');
    } catch (e) {
      _logger.e('💥 Failed to clear all data: $e');
      rethrow;
    }
  }
}
