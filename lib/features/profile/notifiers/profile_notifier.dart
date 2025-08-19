// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:triple_prime_mobile/core/app_router.dart';
import 'package:triple_prime_mobile/core/services/auth_service.dart';
import 'package:triple_prime_mobile/core/services/storage_service.dart';
import 'package:triple_prime_mobile/core/utils/custom_snackbar.dart';
import 'package:triple_prime_mobile/shared/models/auth_models.dart';

class ProfileNotifier extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserData? _currentUser;
  UserData? get currentUser => _currentUser;

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();

  ProfileNotifier() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _storageService.getUserData();
      if (_currentUser != null) {
        _populateControllers();
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _populateControllers() {
    if (_currentUser != null) {
      firstNameController.text = _currentUser!.firstName;
      lastNameController.text = _currentUser!.lastName;
      emailController.text = _currentUser!.email;
      phoneController.text = _currentUser!.phoneNumber ?? '';
      addressController.text = _currentUser!.address ?? '';
    }
  }

  String get fullName {
    if (_currentUser != null) {
      return '${_currentUser!.firstName} ${_currentUser!.lastName}';
    }
    return 'User';
  }

  String get email {
    return _currentUser?.email ?? 'No email provided';
  }

  String get phoneNumber {
    return _currentUser?.phoneNumber ?? 'No phone number provided';
  }

  String get address {
    return _currentUser?.address?.isNotEmpty == true
        ? _currentUser!.address!
        : 'No address provided';
  }

  String get status {
    return _currentUser?.isActive == true ? 'Active Member' : 'Inactive Member';
  }

  Color get statusColor {
    return _currentUser?.isActive == true ? Colors.green : Colors.red;
  }

  void toggleEditMode() {
    _isEditing = !_isEditing;
    if (_isEditing) {
      _populateControllers();
    }
    notifyListeners();
  }

  Future<bool> saveProfileChanges(BuildContext context) async {
    if (!editProfileFormKey.currentState!.validate()) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.updateProfile(
        userId: _currentUser!.id,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        address: addressController.text.trim().isEmpty
            ? null
            : addressController.text.trim(),
      );

      if (response.success && response.data != null) {
        final updatedUser = UserData(
          id: _currentUser!.id,
          userName: _currentUser!.userName,
          normalizedUserName: _currentUser!.normalizedUserName,
          email: emailController.text.trim(),
          normalizedEmail: _currentUser!.normalizedEmail,
          emailConfirmed: _currentUser!.emailConfirmed,
          passwordHash: _currentUser!.passwordHash,
          securityStamp: _currentUser!.securityStamp,
          concurrencyStamp: _currentUser!.concurrencyStamp,
          phoneNumber: phoneController.text.trim(),
          phoneNumberConfirmed: _currentUser!.phoneNumberConfirmed,
          twoFactorEnabled: _currentUser!.twoFactorEnabled,
          lockoutEnd: _currentUser!.lockoutEnd,
          lockoutEnabled: _currentUser!.lockoutEnabled,
          accessFailedCount: _currentUser!.accessFailedCount,
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          address: addressController.text.trim(),
          isActive: _currentUser!.isActive,
          createdAt: _currentUser!.createdAt,
          updatedAt: _currentUser!.updatedAt,
          notificationPreferences: _currentUser!.notificationPreferences,
          deliveryPreferences: _currentUser!.deliveryPreferences,
          languagePreference: _currentUser!.languagePreference,
          deliveryAddresses: _currentUser!.deliveryAddresses,
          paymentMethods: _currentUser!.paymentMethods,
          foodPacks: _currentUser!.foodPacks,
          payments: _currentUser!.payments,
          referrals: _currentUser!.referrals,
          reports: _currentUser!.reports,
          deliveries: _currentUser!.deliveries,
          userRoles: _currentUser!.userRoles,
          savingsPlans: _currentUser!.savingsPlans,
        );

        await _storageService.saveUserData(updatedUser);

        _currentUser = updatedUser;

        _isEditing = false;

        CustomSnackBar.showSuccess(context, 'Profile updated successfully!');

        return true;
      } else {
        String errorMessage = response.message ?? 'Failed to update profile';
        if (response.errors != null && response.errors!.isNotEmpty) {
          errorMessage = response.errors!.first;
        }
        CustomSnackBar.showError(context, errorMessage);
        return false;
      }
    } catch (e) {
      CustomSnackBar.showError(
          context, 'Failed to update profile. Please try again.');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void cancelEdit() {
    _isEditing = false;
    _populateControllers();
    notifyListeners();
  }

  Future<void> refreshUserData() async {
    await _loadUserData();
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _storageService.clearAllAuthData();
      _currentUser = null;

      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRouter.login,
        (route) => false,
      );

      CustomSnackBar.showSuccess(context, 'Logged out successfully');
    } catch (e) {
      CustomSnackBar.showError(context, 'Logout failed. Please try again.');
    }
  }

  Future<bool> changePassword(BuildContext context,
      {VoidCallback? onSuccess, VoidCallback? onError}) async {
    if (!changePasswordFormKey.currentState!.validate()) {
      return false;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      if (onError != null) {
        onError();
      } else {
        CustomSnackBar.showError(context, 'New passwords do not match');
      }
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.changePassword(
        userId: _currentUser!.id,
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
      );

      if (response.success) {
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        if (onSuccess != null) {
          onSuccess();
        } else {
          CustomSnackBar.showSuccess(context, 'Password changed successfully!');
        }
        return true;
      } else {
        String errorMessage = response.message ?? 'Failed to change password';
        if (response.errors != null && response.errors!.isNotEmpty) {
          errorMessage = response.errors!.first;
        }

        if (onError != null) {
          onError();
        } else {
          CustomSnackBar.showError(context, errorMessage);
        }
        return false;
      }
    } catch (e) {
      if (onError != null) {
        onError();
      } else {
        CustomSnackBar.showError(
            context, 'Failed to change password. Please try again.');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
