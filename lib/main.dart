import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triple_prime_mobile/core/theme/app_theme.dart';
import 'package:triple_prime_mobile/features/auth/notifiers/auth_notifier.dart';
import 'package:triple_prime_mobile/core/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthNotifier()),
      ],
      child: const TriplePrimeApp(),
    ),
  );
}

class TriplePrimeApp extends StatelessWidget {
  const TriplePrimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Triple Prime',
      theme: AppTheme.lightTheme(),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouter.landing,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
