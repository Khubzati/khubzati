// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class NoInternetMessage extends StatelessWidget {
  const NoInternetMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          LocaleKeys.app_no_internet_title.tr(),
          style: AppTextStyles.font24Textbold,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          LocaleKeys.app_no_internet_subtitle.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
