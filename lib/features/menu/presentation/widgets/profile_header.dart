import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/core/theme/styles/app_text_style.dart';
import 'package:khubzati/core/widgets/shared_app_background.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedAppBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            children: [
              IconButton(
                onPressed: () => context.router.popForced(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20.sp,
                ),
              ),
              Expanded(
                child: Text(
                  LocaleKeys.app_profile_title.tr(),
                  style: AppTextStyles.font24TextW700
                      .copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: () {
                  context.router.popAndPush(const LoginRoute());
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
