import 'dart:async';

import 'package:bus_booking_app/modules/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../modules/splash/splash_screen.dart';
import '../utils/app_alerts.dart';

class AppRouter {
  static const splash = "/splash";

  static const homeScreen = '/homeScreen';

  static final key = GlobalKey<NavigatorState>();
  static Route onGenerateRoute(RouteSettings settings) {
    debugPrint('Current Route: ${settings.name}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const Scaffold(),
        );
      case AppRouter.splash:
        return _navigate(const SplashScreen());
      case AppRouter.homeScreen:
        return _navigate(const HomeScreen());

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Under development'),
        ),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'This Screen is currently under development!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static _navigate(Widget widget) {
    return MaterialPageRoute(builder: (_) => widget);
  }

  static pushAndReplace(String route) {
    key.currentState!
        .pushNamedAndRemoveUntil(route, (Route<dynamic> route) => false);
  }

  // static push(String route) {
  //   key.currentState!.pushNamed(route);
  // }

  static push(String route, {Object? arguments}) {
    key.currentState!.pushNamed(route, arguments: arguments);
  }

  static pushReplacementNamed(String route, {Object? arguments}) {
    key.currentState!.pushReplacementNamed(route, arguments: arguments);
  }

  static pop() {
    key.currentState!.pop();
  }

  static showAlertWithTitle(String title, String description) {
    AppAlerts().showOSDialog(
      key.currentContext!,
      title,
      description,
      'Ok',
      () => {},
      secondButtonText: "",
      secondCallback: () => {},
    );
  }

  static Future<bool> showAlertCanceltWithStateReturn(
      String title, String description, String yes, String no,
      {void Function()? onYes}) {
    Completer<bool> completer = Completer<bool>();

    AppAlerts().showOSDialog(
      key.currentContext!,
      title,
      description,
      yes,
      onYes ?? () => completer.complete(true),
      secondButtonText: no,
      secondCallback: () => completer.complete(false),
    );

    return completer.future;
  }

  static Future<void> showSuccessAlert(
      {required String message,
      required String icon,
      String subtitle = ''}) async {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      AppRouter.pop();
    });
    return await showDialog(
      context: key.currentContext!,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        return CustomAppAlert(icon: icon, title: message);
      },
    );
  }
}

class CustomAppAlert extends StatelessWidget {
  final String icon;
  final String title;

  const CustomAppAlert({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.80),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(icon),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
      ),
    );
  }
}
