import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'package:lottie/lottie.dart';

import '../gen/assets.gen.dart';
import 'di/injection.dart';
import 'services/app_preferences.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen(
      splashScreenBody: Lottie.asset(
        !getIt<AppPreferences>().isAr
            ? Assets.splash.splashEn
            : Assets.splash.splashAr,
        height: double.infinity,
        width: double.infinity,
        repeat: false,
      ),
      duration: const Duration(seconds: 1, milliseconds: 600),
      useImmersiveMode: true,
      onEnd: () {
        context.router.removeLast();
        context.router.push(const UserTypeSelectionRoute());
      },
    );
  }
}
