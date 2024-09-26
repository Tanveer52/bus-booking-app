import 'package:bus_booking_app/config/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/asset_paths.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateScreen();
  }

  void _navigateScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    AppRouter.pushAndReplace(AppRouter.homeScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xfff5f6f5),
        height: double.infinity,
        width: double.infinity,
        child: Image.asset(AppAssets.appLogo),
      ),
    );
  }
}
