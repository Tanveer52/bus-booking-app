import 'package:bus_booking_app/constants/constants.dart';
import 'package:bus_booking_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'config/app_router.dart';
import 'modules/splash/splash_screen.dart';
import 'theme/theme_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = devPublishableKey;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Booking App',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      navigatorKey: AppRouter.key,
      home: const SplashScreen(),
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
