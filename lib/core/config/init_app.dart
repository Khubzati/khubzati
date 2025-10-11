// ignore_for_file: depend_on_referenced_packages

import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../di/injection.dart';
import '../khubzati_app.dart';
import '../services/localization_service.dart';
import 'app_config.dart';

void initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: AppConfig.shared.firebaseAppName,
    options: AppConfig.shared.firebaseOptions,
  );
  EasyLocalization.logger.enableLevels = [
    LevelMessages.warning,
    LevelMessages.error,
  ];
  await EasyLocalization.ensureInitialized();
  await initDependencies();
  if (kReleaseMode) {
    await ScreenUtil.ensureScreenSize();
  }
  final localizationService = getIt<LocalizationService>();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        builder: (_, __) => EasyLocalization(
          startLocale: const Locale('ar'),
          supportedLocales: localizationService.supportedLocales,
          saveLocale: localizationService.saveLocale,
          path: localizationService.langAssetPath,
          assetLoader: const RootBundleAssetLoader(),
          child: KhubzatiApp(),
        ),
      ),
    ),
  );
}
