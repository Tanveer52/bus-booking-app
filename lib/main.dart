import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/app_router.dart';
import 'modules/splash/splash_screen.dart';
import 'theme/theme_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Assign publishable key to flutter_stripe

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
