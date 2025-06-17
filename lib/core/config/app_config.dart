import 'package:firebase_core/firebase_core.dart';

import 'firebase/firebase_options.dart' as firebase_prod;
import 'firebase/firebase_options_dev.dart' as firebase_dev;
import 'firebase/firebase_options_stage.dart' as firebase_stage;

enum Flavor { dev, stage, prod }

class AppConfig {
  final String appName;
  final String baseUrl;
  final Flavor flavor;
  final String firebaseAppName;
  final FirebaseOptions firebaseOptions;

  static AppConfig shared = AppConfig.create(appProdConfig);

  factory AppConfig.create(AppConfig appConfig) {
    return shared = AppConfig(
      appName: appConfig.appName,
      baseUrl: appConfig.baseUrl,
      flavor: appConfig.flavor,
      firebaseAppName: appConfig.firebaseAppName,
      firebaseOptions: appConfig.firebaseOptions,
    );
  }

  AppConfig(
      {required this.appName,
      required this.baseUrl,
      required this.flavor,
      required this.firebaseAppName,
      required this.firebaseOptions});
}

final appDevConfig = AppConfig(
  appName: "Khubzati Dev",
  baseUrl: "https://khubzati-api-dev.sociumtech.com/api",
  flavor: Flavor.dev,
  firebaseAppName: "khubzati-Dev",
  firebaseOptions: firebase_dev.DefaultFirebaseOptions.currentPlatform,
);

final appStageConfig = AppConfig(
  appName: "Khubzati Stage",
  baseUrl: "https://khubzati-api-staging.sociumtech.com/api",
  flavor: Flavor.stage,
  firebaseAppName: "khubzati-Stage",
  firebaseOptions: firebase_stage.DefaultFirebaseOptions.currentPlatform,
);

final appProdConfig = AppConfig(
  appName: "Khubzati Prod",
  baseUrl: "https://khubzati-api-dev.sociumtech.com/api",
  flavor: Flavor.prod,
  firebaseAppName: "khubzati-Prod",
  firebaseOptions: firebase_prod.DefaultFirebaseOptions.currentPlatform,
);
