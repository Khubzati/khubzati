import 'package:flutter/material.dart';

import '../../gen/fonts.gen.dart';
import '../di/injection.dart';
import '../services/app_preferences.dart';
import 'styles/app_button_style.dart';
import 'styles/app_colors.dart';
import 'styles/app_input_style.dart';
import 'styles/app_text_style.dart';

ThemeData get appThemeData {
  final isAr = getIt<AppPreferences>().isAr;
  return ThemeData(
    fontFamily: isAr ? FontFamily.gEDinarOne : FontFamily.lato,
    elevatedButtonTheme: appElevatedButtonTheme,
    textTheme: appTextTheme,
    inputDecorationTheme: appInputDecorationTheme,
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppColors.primaryBurntOrange,
      surfaceTint: Colors.white,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
      },
    ),
  );
}
