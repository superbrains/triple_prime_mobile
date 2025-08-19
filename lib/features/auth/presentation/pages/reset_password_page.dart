// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triple_prime_mobile/core/theme/app_theme.dart';
import 'package:triple_prime_mobile/shared/widgets/custom_button.dart';
import 'package:triple_prime_mobile/shared/widgets/custom_text_field.dart';
import '../../notifiers/auth_notifier.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool _formValid = false;

  void _validateForm(AuthNotifier authNotifier) {
    final isValid =
        authNotifier.resetPasswordFormKey.currentState?.validate() ?? false;
    if (_formValid != isValid) {
      setState(() {
        _formValid = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.watch<AuthNotifier>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
            child: Form(
              key: authNotifier.resetPasswordFormKey,
              onChanged: () => _validateForm(authNotifier),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Text(
                    'Reset Password',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Enter the verification code sent to your email and create a new password',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black54,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Email field (pre-filled and read-only)
                  CustomTextField(
                    label: 'Email',
                    controller: TextEditingController(
                        text: authNotifier.resetEmail ?? ''),
                    enabled: false,
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 24),

                  // OTP field
                  CustomTextField(
                    label: 'Verification Code',
                    hint: 'Enter 6-digit code',
                    controller: authNotifier.resetPasswordOtpController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.security,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the verification code';
                      }
                      if (value.length != 6) {
                        return 'Verification code must be 6 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // New password field
                  CustomTextField(
                    label: 'New Password',
                    hint: 'Enter your new password',
                    controller: authNotifier.resetPasswordNewPasswordController,
                    obscureText: authNotifier.resetPasswordObscurePassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(authNotifier.resetPasswordObscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed:
                          authNotifier.toggleResetPasswordObscurePassword,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Confirm password field
                  CustomTextField(
                    label: 'Confirm New Password',
                    hint: 'Confirm your new password',
                    controller:
                        authNotifier.resetPasswordConfirmPasswordController,
                    obscureText:
                        authNotifier.resetPasswordObscureConfirmPassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                          authNotifier.resetPasswordObscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                      onPressed: authNotifier
                          .toggleResetPasswordObscureConfirmPassword,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password';
                      }
                      if (value !=
                          authNotifier
                              .resetPasswordNewPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Reset password button
                  CustomButton(
                    text: 'Reset Password',
                    isLoading: authNotifier.isLoading,
                    onPressed: _formValid && !authNotifier.isLoading
                        ? () async {
                            if (authNotifier.resetPasswordFormKey.currentState
                                    ?.validate() ??
                                false) {
                              // Set the email from the stored reset email
                              authNotifier.resetPasswordEmailController.text =
                                  authNotifier.resetEmail ?? '';

                              final success =
                                  await authNotifier.resetPassword(context);
                              if (success && mounted) {
                                // Navigate back to login
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              }
                            }
                          }
                        : () {},
                  ),
                  const SizedBox(height: 24),

                  // Resend code option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Didn't receive the code? ",
                          style: TextStyle(color: Colors.black54)),
                      GestureDetector(
                        onTap: () {
                          // Go back to forgot password page to resend
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Resend Code',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
