import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:khubzati/gen/fonts.gen.dart';
import '../../di/injection.dart';
import '../../services/app_preferences.dart';
import 'app_colors.dart';

TextTheme get appTextTheme {
  final isAr = getIt<AppPreferences>().isAr;
  return Typography.englishLike2021.merge(Typography.blackRedwoodCity).apply(
        decorationColor: AppColors.textDarkBrown,
        bodyColor: AppColors.textDarkBrown,
        displayColor: AppColors.textDarkBrown,
        fontFamily: isAr ? FontFamily.gEDinarOne : FontFamily.lato,
      );
}

class AppTextStyles {
  static const TextStyle phoneNumber = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textDarkBrown,
  );

  static TextStyle otpInput = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textDarkBrown,
  );

  static TextStyle font24Textbold = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textDarkBrown,
  );

  static TextStyle font14TextW400OP8 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textDarkBrown.withOpacity(0.8),
  );

  static TextStyle font14Primary700 = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.primaryBurntOrange);

  static TextStyle font16textDarkBrownBold = TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.textDarkBrown);

  static TextStyle font15TextW400 = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textDarkBrown,
  );

  static TextStyle font16TextW500 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.creamColor,
  );

  static TextStyle font16BurntOrange500 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryBurntOrange,
  );

  static TextStyle font16PrimaryBold = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryBurntOrange,
  );

  static TextStyle font20TextW500 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryLightCream,
    decoration: TextDecoration.none,
  );

  static TextStyle font24TextW400 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textDarkBrown,
  );

  static TextStyle font20textDarkBrownbold = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textDarkBrown,
  );

  static TextStyle font24TextW700 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.secondaryLightCream,
    decoration: TextDecoration.none,
  );

  static TextStyle font32TextW700 = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textDarkBrown,
  );

  static TextStyle font47TextW700 = TextStyle(
    fontSize: 47.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.secondaryLightCream,
    decoration: TextDecoration.none,
  );
}
