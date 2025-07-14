import 'package:logger/logger.dart';
import 'package:triple_prime_mobile/core/constants/app_constants.dart';
import 'package:triple_prime_mobile/core/utils/network_service.dart';
import 'package:triple_prime_mobile/shared/models/auth_models.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  final NetworkService _networkService = NetworkService();
  final _logger = Logger();

  AuthService._internal();

  /// Register a new user
  Future<ApiResponse<AuthResponse>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String address,
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

      _logger.d('📤 Register request data: ${request.toJson()}');

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

      if (response.success && response.data != null) {
        // Save the auth token if it exists
        if (response.data!.token != null) {
          await _networkService.saveAuthToken(response.data!.token!);
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
  Future<ApiResponse<AuthResponse>> login({
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

      final response = await _networkService.post<AuthResponse>(
        AppConstants.authLogin,
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

      if (response.success && response.data != null) {
        // Save the auth token if it exists
        if (response.data!.token != null) {
          await _networkService.saveAuthToken(response.data!.token!);
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

      // Clear the auth token
      await _networkService.clearAuthToken();

      _logger.i('✅ Logout successful');
    } catch (e) {
      _logger.e('💥 Logout error: $e');
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final token = await _networkService.getAuthToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      _logger.e('💥 Authentication check error: $e');
      return false;
    }
  }

  /// Get current auth token
  Future<String?> getAuthToken() async {
    try {
      return await _networkService.getAuthToken();
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
        await _networkService.saveAuthToken(response.data!.token!);
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
}
