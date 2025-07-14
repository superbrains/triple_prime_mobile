import 'package:flutter/material.dart';
import 'package:triple_prime_mobile/features/auth/presentation/pages/landing_page.dart';
import 'package:triple_prime_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:triple_prime_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:triple_prime_mobile/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:triple_prime_mobile/features/auth/presentation/pages/reset_password_page.dart';

class AppRouter {
  static const String landing = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case landing:
        return _fadeRoute(const LandingPage(), settings);
      case login:
        return _slideRoute(const LoginPage(), settings);
      case register:
        return _slideRoute(const RegisterPage(), settings);
      case forgotPassword:
        return _slideRoute(const ForgotPasswordPage(), settings);
      case resetPassword:
        return _slideRoute(const ResetPasswordPage(), settings);
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }

  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  static PageRouteBuilder _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
