// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:triple_prime_mobile/core/app_router.dart';
import 'package:triple_prime_mobile/core/services/auth_service.dart';
import 'package:triple_prime_mobile/core/services/storage_service.dart';
import 'package:triple_prime_mobile/core/utils/custom_snackbar.dart';
import 'package:triple_prime_mobile/shared/models/auth_models.dart';

class AuthNotifier extends ChangeNotifier {
  // Services
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  // Controllers
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final registerFirstNameController = TextEditingController();
  final registerLastNameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPhoneController = TextEditingController();
  final registerAddressController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerConfirmPasswordController = TextEditingController();

  // Forgot password controllers
  final forgotPasswordEmailController = TextEditingController();

  // Reset password controllers (OTP-based)
  final resetPasswordEmailController = TextEditingController();
  final resetPasswordOtpController = TextEditingController();
  final resetPasswordNewPasswordController = TextEditingController();
  final resetPasswordConfirmPasswordController = TextEditingController();

  // Form keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final forgotPasswordFormKey = GlobalKey<FormState>();
  final resetPasswordFormKey = GlobalKey<FormState>();

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Authentication state
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  UserData? _currentUser;
  UserData? get currentUser => _currentUser;

  // Forgot password state
  String? _resetEmail;
  String? get resetEmail => _resetEmail;
  void setResetEmail(String email) {
    _resetEmail = email;
    notifyListeners();
  }

  // Password visibility
  bool _loginObscurePassword = true;
  bool get loginObscurePassword => _loginObscurePassword;
  void toggleLoginObscurePassword() {
    _loginObscurePassword = !_loginObscurePassword;
    notifyListeners();
  }

  bool _registerObscurePassword = true;
  bool get registerObscurePassword => _registerObscurePassword;
  void toggleRegisterObscurePassword() {
    _registerObscurePassword = !_registerObscurePassword;
    notifyListeners();
  }

  bool _registerObscureConfirmPassword = true;
  bool get registerObscureConfirmPassword => _registerObscureConfirmPassword;
  void toggleRegisterObscureConfirmPassword() {
    _registerObscureConfirmPassword = !_registerObscureConfirmPassword;
    notifyListeners();
  }

  bool _resetPasswordObscurePassword = true;
  bool get resetPasswordObscurePassword => _resetPasswordObscurePassword;
  void toggleResetPasswordObscurePassword() {
    _resetPasswordObscurePassword = !_resetPasswordObscurePassword;
    notifyListeners();
  }

  bool _resetPasswordObscureConfirmPassword = true;
  bool get resetPasswordObscureConfirmPassword =>
      _resetPasswordObscureConfirmPassword;
  void toggleResetPasswordObscureConfirmPassword() {
    _resetPasswordObscureConfirmPassword =
        !_resetPasswordObscureConfirmPassword;
    notifyListeners();
  }

  // Terms agreement
  bool _agreedToTerms = false;
  bool get agreedToTerms => _agreedToTerms;
  void setAgreedToTerms(bool value) {
    _agreedToTerms = value;
    notifyListeners();
  }

  // Initialize authentication state
  Future<void> initializeAuth() async {
    _isAuthenticated = await _storageService.isAuthenticated();

    // Load user data from storage if authenticated
    if (_isAuthenticated) {
      _currentUser = await _storageService.getUserData();
    }

    notifyListeners();
  }

  // Login method
  Future<bool> login(BuildContext context) async {
    if (!loginFormKey.currentState!.validate()) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.login(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text,
      );

      if (response.success &&
          response.data != null &&
          response.data!.data != null) {
        _currentUser = response.data?.data?.user;

        loginEmailController.clear();
        loginPasswordController.clear();

        CustomSnackBar.showSuccess(context, 'Login successful!');

        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRouter.mainScreen,
          (route) => false,
        );

        return true;
      } else {
        // Show more specific error message if available
        String errorMessage = response.message ?? 'Login failed';

        // If there are specific errors, show the first one
        if (response.errors != null && response.errors!.isNotEmpty) {
          errorMessage = response.errors!.first;
        }

        CustomSnackBar.showError(context, errorMessage);
        return false;
      }
    } catch (e) {
      CustomSnackBar.showError(context, 'An unexpected error occurred');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register method
  Future<bool> register(BuildContext context) async {
    if (!registerFormKey.currentState!.validate()) {
      return false;
    }

    if (!_agreedToTerms) {
      CustomSnackBar.showError(
          context, 'Please agree to the terms and conditions');
      return false;
    }

    if (registerPasswordController.text !=
        registerConfirmPasswordController.text) {
      CustomSnackBar.showError(context, 'Passwords do not match');
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.register(
        email: registerEmailController.text.trim(),
        password: registerPasswordController.text,
        firstName: registerFirstNameController.text.trim(),
        lastName: registerLastNameController.text.trim(),
        phoneNumber: registerPhoneController.text.trim().isEmpty
            ? null
            : registerPhoneController.text.trim(),
        address: registerAddressController.text.trim().isEmpty
            ? null
            : registerAddressController.text.trim(),
      );

      if (response.success && response.data != null) {
        _isAuthenticated = true;
        _currentUser = response.data!.user;

        // Clear form
        _clearRegisterForm();

        CustomSnackBar.showSuccess(context, 'Registration successful!');
        Navigator.of(context).pushNamed(AppRouter.login);
        return true;
      } else {
        // Show more specific error message if available
        String errorMessage = response.message ?? 'Registration failed';

        // If there are specific errors, show the first one
        if (response.errors != null && response.errors!.isNotEmpty) {
          errorMessage = response.errors!.first;
        }

        CustomSnackBar.showError(context, errorMessage);
        return false;
      }
    } catch (e) {
      CustomSnackBar.showError(context, 'An unexpected error occurred');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout method
  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();

      _isAuthenticated = false;
      _currentUser = null;

      // Clear all forms
      _clearAllForms();

      CustomSnackBar.showSuccess(context, 'Logged out successfully');
    } catch (e) {
      CustomSnackBar.showError(context, 'Logout failed');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Forgot password method - Step 1: Send OTP
  Future<bool> forgotPassword(BuildContext context) async {
    if (!forgotPasswordFormKey.currentState!.validate()) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.forgotPassword(
        email: forgotPasswordEmailController.text.trim(),
      );

      if (response.success) {
        forgotPasswordEmailController.clear();
        Navigator.pop(context);
        CustomSnackBar.showSuccess(
            context, 'Verification code sent to your email');
        return true;
      } else {
        forgotPasswordEmailController.clear();
        CustomSnackBar.showError(
            context, response.message ?? 'Failed to send verification code');
        return false;
      }
    } catch (e) {
      CustomSnackBar.showError(context, 'An unexpected error occurred');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset password method - Step 2: Verify OTP and set new password
  Future<bool> resetPassword(BuildContext context) async {
    if (!resetPasswordFormKey.currentState!.validate()) {
      return false;
    }

    if (resetPasswordNewPasswordController.text !=
        resetPasswordConfirmPasswordController.text) {
      CustomSnackBar.showError(context, 'Passwords do not match');
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.resetPassword(
        email: resetPasswordEmailController.text.trim(),
        otp: resetPasswordOtpController.text.trim(),
        newPassword: resetPasswordNewPasswordController.text,
      );

      if (response.success) {
        _clearResetPasswordForm();
        _resetEmail = null; // Clear stored email
        CustomSnackBar.showSuccess(context, 'Password reset successful!');
        return true;
      } else {
        CustomSnackBar.showError(
            context, response.message ?? 'Password reset failed');
        return false;
      }
    } catch (e) {
      CustomSnackBar.showError(context, 'An unexpected error occurred');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper methods to clear forms
  void _clearRegisterForm() {
    registerFirstNameController.clear();
    registerLastNameController.clear();
    registerEmailController.clear();
    registerPhoneController.clear();
    registerAddressController.clear();
    registerPasswordController.clear();
    registerConfirmPasswordController.clear();
    _agreedToTerms = false;
  }

  void _clearResetPasswordForm() {
    resetPasswordEmailController.clear();
    resetPasswordOtpController.clear();
    resetPasswordNewPasswordController.clear();
    resetPasswordConfirmPasswordController.clear();
    forgotPasswordEmailController.clear();
  }

  void _clearAllForms() {
    loginEmailController.clear();
    loginPasswordController.clear();
    _clearRegisterForm();
    _clearResetPasswordForm();
    _resetEmail = null;
  }

  @override
  void dispose() {
    // Dispose controllers
    loginEmailController.dispose();
    loginPasswordController.dispose();
    registerFirstNameController.dispose();
    registerLastNameController.dispose();
    registerEmailController.dispose();
    registerPhoneController.dispose();
    registerAddressController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();
    forgotPasswordEmailController.dispose();
    resetPasswordEmailController.dispose();
    resetPasswordOtpController.dispose();
    resetPasswordNewPasswordController.dispose();
    resetPasswordConfirmPasswordController.dispose();
    super.dispose();
  }
}
