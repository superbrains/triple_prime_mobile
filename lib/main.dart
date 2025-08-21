import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:triple_prime_mobile/firebase_options.dart';
import 'package:triple_prime_mobile/core/theme/app_theme.dart';
import 'package:triple_prime_mobile/features/auth/notifiers/auth_notifier.dart';
import 'package:triple_prime_mobile/features/food_packs/notifiers/food_pack_notifier.dart';
import 'package:triple_prime_mobile/features/profile/notifiers/profile_notifier.dart';
import 'package:triple_prime_mobile/features/savings/notifiers/savings_plan_notifier.dart';
import 'package:triple_prime_mobile/core/app_router.dart';
import 'package:triple_prime_mobile/features/dashboard/presentation/pages/main_screen.dart';
import 'package:triple_prime_mobile/core/services/env_service.dart';
import 'package:triple_prime_mobile/core/services/push_notification_service.dart';
import 'package:triple_prime_mobile/core/services/paystack_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await EnvService.init();
  await PushNotificationService.initialize();
  await PaystackService().initialize();

  final authNotifier = AuthNotifier();
  await authNotifier.initializeAuth();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authNotifier),
        ChangeNotifierProvider(create: (_) => FoodPackNotifier()),
        ChangeNotifierProvider(create: (_) => SavingsPlanNotifier()),
        ChangeNotifierProvider(create: (_) => ProfileNotifier()),
      ],
      child: const TriplePrimeApp(),
    ),
  );
}

class TriplePrimeApp extends StatelessWidget {
  const TriplePrimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    PushNotificationService.setContext(context);

    return MaterialApp(
      title: 'Triple Prime',
      theme: AppTheme.lightTheme(),
      debugShowCheckedModeBanner: false,
      home: Consumer<AuthNotifier>(
        builder: (context, authNotifier, child) {
          if (authNotifier.isAuthenticated) {
            return const MainScreen();
          }
          return const Navigator(
            initialRoute: AppRouter.landing,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
