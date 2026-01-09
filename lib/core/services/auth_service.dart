import 'dart:developer';

import 'package:logger/logger.dart';
import 'package:triple_prime_mobile/core/constants/app_constants.dart';
import 'package:triple_prime_mobile/core/services/storage_service.dart';
import 'package:triple_prime_mobile/core/utils/network_service.dart';
import 'package:triple_prime_mobile/shared/models/auth_models.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  final NetworkService _networkService = NetworkService();
  final StorageService _storageService = StorageService();
  final _logger = Logger();

  AuthService._internal();

  /// Register a new user
  Future<ApiResponse<AuthResponse>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String? address,
    String? referralCode,
  }) async {
    try {
      _logger.i('🔄 Starting registration process for: $email');

      final request = RegisterRequest(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        address: address,
        referralCode: referralCode,
      );

      log('📤 Register request data: ${request.toJson()}');

      final response = await _networkService.post<AuthResponse>(
        AppConstants.authRegister,
        data: request.toJson(),
        fromJson: (json) {
          _logger.d('🔍 Parsing response JSON: $json');
          try {
            return AuthResponse.fromJson(json);
          } catch (e) {
            _logger.e('💥 Failed to parse AuthResponse: $e');
            rethrow;
          }
        },
      );
      log('response: $response');
      if (response.success && response.data != null) {
        // Save the auth token if it exists
        if (response.data!.token != null) {
          await _storageService.saveAuthToken(response.data?.token ?? '');
        }
        _logger.i('✅ Registration successful for: $email');
      } else {
        _logger.e('❌ Registration failed for: $email - ${response.message}');
        if (response.errors != null && response.errors!.isNotEmpty) {
          _logger.e('🚫 Specific errors: ${response.errors}');
        }
      }

      return response;
    } catch (e) {
      _logger.e('💥 Registration error: $e');
      return ApiResponse.error(
        message: 'Registration failed. Please try again.',
        statusCode: 500,
      );
    }
  }

  /// Login user
  Future<ApiResponse<LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      _logger.i('🔄 Starting login process for: $email');

      final request = LoginRequest(
        email: email,
        password: password,
      );

      _logger.d('📤 Login request data: ${request.toJson()}');

      final response = await _networkService.post<LoginResponse>(
        AppConstants.authLogin,
        data: request.toJson(),
        fromJson: (json) {
          _logger.i('🔍 Parsing response JSON: $json');
          try {
            return LoginResponse.fromJson(json);
          } catch (e) {
            _logger.e('💥 Failed to parse LoginResponse: $e');
            rethrow;
          }
        },
      );

      if (response.success &&
          response.data != null &&
          response.data!.data != null) {
        // Extract token from claims
        final claims = response.data!.data!.claims;
        if (claims != null) {
          final tokenClaim = claims.firstWhere(
            (claim) => claim.type == 'token',
            orElse: () => const Claim(
              issuer: '',
              originalIssuer: '',
              properties: {},
              type: '',
              value: '',
              valueType: '',
            ),
          );

          if (tokenClaim.value.isNotEmpty) {
            await _storageService.saveAuthToken(tokenClaim.value);
          }
        }

        // Save user data to secure storage
        if (response.data?.data?.user != null) {
          await _storageService.saveUserData(response.data!.data!.user!);
          _logger.i('💾 User data saved to secure storage');
        }

        _logger.i('✅ Login successful for: $email');
      } else {
        _logger.e('❌ Login failed for: $email - ${response.message}');
        if (response.errors != null && response.errors!.isNotEmpty) {
          _logger.e('🚫 Specific errors: ${response.errors}');
        }
      }

      return response;
    } catch (e) {
      _logger.e('💥 Login error: $e');
      return ApiResponse.error(
        message: 'Login failed. Please try again.',
        statusCode: 500,
      );
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      _logger.i('🔄 Starting logout process');

      // Clear all auth data (token + user data)
      await _storageService.clearAllAuthData();

      _logger.i('✅ Logout successful');
    } catch (e) {
      _logger.e('💥 Logout error: $e');
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      return await _storageService.isAuthenticated();
    } catch (e) {
      _logger.e('💥 Authentication check error: $e');
      return false;
    }
  }

  /// Get current user data from storage
  Future<UserData?> getCurrentUser() async {
    try {
      return await _storageService.getUserData();
    } catch (e) {
      _logger.e('💥 Get current user error: $e');
      return null;
    }
  }

  /// Get current auth token
  Future<String?> getAuthToken() async {
    try {
      return await _storageService.getAuthToken();
    } catch (e) {
      _logger.e('💥 Get auth token error: $e');
      return null;
    }
  }

  /// Refresh auth token (if needed)
  Future<ApiResponse<AuthResponse>> refreshToken() async {
    try {
      _logger.i('🔄 Starting token refresh');

      final response = await _networkService.post<AuthResponse>(
        AppConstants.authRefreshToken,
        fromJson: (json) => AuthResponse.fromJson(json),
      );

      if (response.success && response.data?.token != null) {
        // Save the new auth token
        await _storageService.saveAuthToken(response.data?.token ?? '');
        _logger.i('✅ Token refresh successful');
      } else {
        _logger.e('❌ Token refresh failed - ${response.message}');
      }

      return response;
    } catch (e) {
      _logger.e('💥 Token refresh error: $e');
      return ApiResponse.error(
        message: 'Token refresh failed.',
        statusCode: 500,
      );
    }
  }

  /// Forgot password - Step 1: Send OTP to email
  Future<ApiResponse<AuthResponse>> forgotPassword({
    required String email,
  }) async {
    try {
      _logger.i('🔄 Starting forgot password process for: $email');

      final response = await _networkService.post<AuthResponse>(
        AppConstants.authForgotPassword,
        data: {'email': email},
        fromJson: (json) => AuthResponse.fromJson(json),
      );

      if (response.success) {
        _logger.i('✅ OTP sent successfully for: $email');
      } else {
        _logger.e('❌ Failed to send OTP for: $email - ${response.message}');
      }

      return response;
    } catch (e) {
      _logger.e('💥 Forgot password error: $e');
      return ApiResponse.error(
        message: 'Failed to send OTP. Please try again.',
        statusCode: 500,
      );
    }
  }

  /// Reset password - Step 2: Verify OTP and set new password
  Future<ApiResponse<AuthResponse>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      _logger.i('🔄 Starting password reset process for: $email');

      final response = await _networkService.post<AuthResponse>(
        AppConstants.authResetPassword,
        data: {
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        },
        fromJson: (json) => AuthResponse.fromJson(json),
      );

      if (response.success) {
        _logger.i('✅ Password reset successful for: $email');
      } else {
        _logger.e('❌ Password reset failed for: $email - ${response.message}');
      }

      return response;
    } catch (e) {
      _logger.e('💥 Password reset error: $e');
      return ApiResponse.error(
        message: 'Password reset failed. Please try again.',
        statusCode: 500,
      );
    }
  }

  /// Update user profile
  Future<ApiResponse<AuthResponse>> updateProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    String? phoneNumber,
    String? address,
  }) async {
    try {
      _logger.i('🔄 Starting profile update process for user: $userId');

      final request = ProfileUpdateRequest(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        address: address,
      );

      _logger.d('📤 Profile update request data: ${request.toJson()}');

      final response = await _networkService.put<AuthResponse>(
        '${AppConstants.userProfileUpdate}/$userId',
        data: request.toJson(),
        fromJson: (json) {
          _logger.d('🔍 Parsing profile update response JSON: $json');
          try {
            return AuthResponse.fromJson(json);
          } catch (e) {
            _logger.e('💥 Failed to parse AuthResponse: $e');
            rethrow;
          }
        },
      );

      if (response.success && response.data != null) {
        _logger.i('✅ Profile update successful for user: $userId');
      } else {
        _logger.e(
            '❌ Profile update failed for user: $userId - ${response.message}');
        if (response.errors != null && response.errors!.isNotEmpty) {
          _logger.e('🚫 Specific errors: ${response.errors}');
        }
      }

      return response;
    } catch (e) {
      _logger.e('💥 Profile update error: $e');
      return ApiResponse.error(
        message: 'Profile update failed. Please try again.',
        statusCode: 500,
      );
    }
  }

  Future<ApiResponse<AuthResponse>> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      _logger.i('🔄 Starting password change process for user: $userId');

      final request = {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };

      _logger.d('📤 Password change request data: $request');

      final response = await _networkService.put<AuthResponse>(
        '${AppConstants.userChangePassword}/$userId',
        data: request,
        fromJson: (json) {
          _logger.d('🔍 Parsing password change response JSON: $json');
          try {
            return AuthResponse.fromJson(json);
          } catch (e) {
            _logger.e('💥 Failed to parse AuthResponse: $e');
            rethrow;
          }
        },
      );

      if (response.success) {
        _logger.i('✅ Password change successful for user: $userId');
      } else {
        _logger.e(
            '❌ Password change failed for user: $userId - ${response.message}');
        if (response.errors != null && response.errors!.isNotEmpty) {
          _logger.e('🚫 Specific errors: ${response.errors}');
        }
      }

      return response;
    } catch (e) {
      _logger.e('💥 Password change error: $e');
      return ApiResponse.error(
        message: 'Password change failed. Please try again.',
        statusCode: 500,
      );
    }
  }

  /// Delete user account
  Future<ApiResponse<AuthResponse>> deleteUser({
    required String userId,
  }) async {
    try {
      _logger.i('🔄 Starting account deletion process for user: $userId');

      final response = await _networkService.delete<AuthResponse>(
        '${AppConstants.userDelete}/$userId',
        fromJson: (json) {
          _logger.d('🔍 Parsing delete user response JSON: $json');
          try {
            return AuthResponse.fromJson(json);
          } catch (e) {
            _logger.e('💥 Failed to parse AuthResponse: $e');
            rethrow;
          }
        },
      );

      if (response.success) {
        _logger.i('✅ Account deletion successful for user: $userId');
        // Clear all auth data after successful deletion
        await _storageService.clearAllAuthData();
      } else {
        _logger.e(
            '❌ Account deletion failed for user: $userId - ${response.message}');
        if (response.errors != null && response.errors!.isNotEmpty) {
          _logger.e('🚫 Specific errors: ${response.errors}');
        }
      }

      return response;
    } catch (e) {
      _logger.e('💥 Account deletion error: $e');
      return ApiResponse.error(
        message: 'Account deletion failed. Please try again.',
        statusCode: 500,
      );
    }
  }
}
