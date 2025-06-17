import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';
import 'app_text_style.dart';

final buttonHeight = 48.w;

final appElevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    textStyle: AppTextStyles.font16TextW500,
    backgroundColor: AppColors.primaryBurntOrange,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.r),
    ),
    fixedSize: Size(double.maxFinite, buttonHeight),
  ),
);
