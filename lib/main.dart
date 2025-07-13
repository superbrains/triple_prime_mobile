import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:triple_prime_mobile/core/theme/app_theme.dart';
import 'package:triple_prime_mobile/features/auth/presentation/pages/landing_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TriplePrimeApp());
}

class TriplePrimeApp extends StatelessWidget {
  const TriplePrimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Triple Prime',
      theme: AppTheme.lightTheme(),
      debugShowCheckedModeBanner: false,
      home: const LandingPage(),
    );
  }
}
