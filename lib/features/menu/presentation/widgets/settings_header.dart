import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/widgets/shared_app_background.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

/// Settings header widget with blurred background
/// Following clean architecture and responsive design
class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedAppBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            children: [
              // Back Button
              IconButton(
                onPressed: () => context.router.popForced(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20.sp,
                  color: Colors.white,
                ),
              ),
              // Title
              Text(
                LocaleKeys.app_navigation_settings.tr(),
                style: AppTextStyles.font24TextW700.copyWith(
                  color: Colors.white,
                ),
              ),
              // Spacer for symmetry
              40.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
