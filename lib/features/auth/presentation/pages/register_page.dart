import 'package:flutter/material.dart';
import 'package:triple_prime_mobile/shared/widgets/custom_button.dart';
import 'package:triple_prime_mobile/shared/widgets/custom_text_field.dart';
import 'package:triple_prime_mobile/core/theme/app_theme.dart';
import 'package:triple_prime_mobile/core/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';
import '../../notifiers/auth_notifier.dart';
import 'package:triple_prime_mobile/core/app_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as developer;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final authNotifier = context.watch<AuthNotifier>();
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: Navigator.canPop(context)
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
            )
          : null,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
            child: Form(
              key: authNotifier.registerFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create an Account',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'First Name',
                          hint: 'John',
                          controller: authNotifier.registerFirstNameController,
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter first name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextField(
                          label: 'Last Name',
                          hint: 'Doe',
                          controller: authNotifier.registerLastNameController,
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter last name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Email',
                    hint: 'john@example.com',
                    controller: authNotifier.registerEmailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Phone Number',
                    hint: '+234 800 000 0000',
                    controller: authNotifier.registerPhoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    validator: (value) {
                      // Phone number is optional, so no validation required
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Address',
                    hint: 'Enter your full address',
                    controller: authNotifier.registerAddressController,
                    prefixIcon: Icons.location_on_outlined,
                    validator: (value) {
                      // Address is optional, so no validation required
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Password',
                    hint: 'Enter your password',
                    controller: authNotifier.registerPasswordController,
                    obscureText: authNotifier.registerObscurePassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(authNotifier.registerObscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: authNotifier.toggleRegisterObscurePassword,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Confirm Password',
                    hint: 'Re-enter your password',
                    controller: authNotifier.registerConfirmPasswordController,
                    obscureText: authNotifier.registerObscureConfirmPassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(authNotifier.registerObscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed:
                          authNotifier.toggleRegisterObscureConfirmPassword,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm your password';
                      }
                      if (value !=
                          authNotifier.registerPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: authNotifier.agreedToTerms,
                        activeColor: AppTheme.primaryColor,
                        onChanged: (value) {
                          authNotifier.setAgreedToTerms(value ?? false);
                        },
                      ),
                      const Text('I agree to the '),
                      GestureDetector(
                        onTap: () async {
                          final Uri url =
                              Uri.parse('https://tripleprime.com.ng/terms');
                          try {
                            developer.log(
                                'Attempting to launch Terms URL: ${url.toString()}');

                            final canLaunch = await canLaunchUrl(url);
                            developer.log('Can launch Terms URL: $canLaunch');

                            if (canLaunch) {
                              final result = await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                              developer.log('Terms launch result: $result');

                              if (!result && context.mounted) {
                                CustomSnackBar.showError(
                                  context,
                                  'Could not launch Terms and Conditions',
                                );
                              }
                            } else {
                              developer.log(
                                  'Cannot launch Terms URL: ${url.toString()}');
                              if (context.mounted) {
                                CustomSnackBar.showError(
                                  context,
                                  'No app available to open Terms and Conditions',
                                );
                              }
                            }
                          } catch (e) {
                            developer.log('Error launching Terms URL: $e');
                            if (context.mounted) {
                              CustomSnackBar.showError(
                                context,
                                'Error opening Terms and Conditions: ${e.toString()}',
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Terms and Conditions',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CustomButton(
                    text: 'Register',
                    isLoading: authNotifier.isLoading,
                    onPressed:
                        authNotifier.agreedToTerms && !authNotifier.isLoading
                            ? () {
                                if (authNotifier.registerFormKey.currentState
                                        ?.validate() ??
                                    false) {
                                  authNotifier.register(context);
                                }
                              }
                            : () {},
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? ',
                          style: TextStyle(color: Colors.black54)),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRouter.login);
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
