import 'package:flutter/material.dart';
import 'package:triple_prime_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:triple_prime_mobile/shared/widgets/custom_button.dart';
import 'package:triple_prime_mobile/shared/widgets/custom_text_field.dart';
import 'package:triple_prime_mobile/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../../notifiers/auth_notifier.dart';
import 'package:triple_prime_mobile/core/app_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _formValid = false;

  void _validateForm(AuthNotifier authNotifier) {
    final isValid = authNotifier.loginFormKey.currentState?.validate() ?? false;
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
              key: authNotifier.loginFormKey,
              onChanged: () => _validateForm(authNotifier),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    label: 'Email',
                    hint: 'john@example.com',
                    controller: authNotifier.loginEmailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Password',
                    hint: 'Enter your password',
                    controller: authNotifier.loginPasswordController,
                    obscureText: authNotifier.loginObscurePassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(authNotifier.loginObscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: authNotifier.toggleLoginObscurePassword,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AppRouter.forgotPassword);
                      },
                      style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor),
                      child: const Text('Forgot password?'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Login',
                    isLoading: authNotifier.isLoading,
                    onPressed: _formValid && !authNotifier.isLoading
                        ? () {
                            if (authNotifier.loginFormKey.currentState
                                    ?.validate() ??
                                false) {
                              authNotifier.login(context);
                            }
                          }
                        : () {},
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ",
                          style: TextStyle(color: Colors.black54)),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RegisterPage()));
                        },
                        child: const Text(
                          'Create an account',
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
