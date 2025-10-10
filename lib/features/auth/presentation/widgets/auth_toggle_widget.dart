import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/styles/app_colors.dart';
import '../../../../gen/translations/locale_keys.g.dart';

class AuthToggleWidget extends StatelessWidget {
  const AuthToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          context.router.push(const SignupRoute());
        },
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.app_auth_no_account_prompt.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textDarkBrown.withOpacity(0.7),
                  height: 1.4,
                ),
              ),
              TextSpan(
                text: ' ',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textDarkBrown.withOpacity(0.7),
                ),
              ),
              TextSpan(
                text: LocaleKeys.app_auth_signup_link.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBurntOrange,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primaryBurntOrange,
                  decorationThickness: 1.5,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
