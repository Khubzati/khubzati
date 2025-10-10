import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/styles/app_text_style.dart';
import '../../../../core/widgets/app_elevated_button.dart';
import '../../../../core/widgets/background_with_logo.dart';
import '../../../../gen/translations/locale_keys.g.dart';

@RoutePage()
class VerifyPage extends StatelessWidget {
  const VerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundWithLogo(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  80.verticalSpace, // Space at the top
                  Text(
                    context.tr(LocaleKeys.app_userTypeSelection_WelcomeText),
                    style: AppTextStyles.font24TextW700,
                    textAlign: TextAlign.center,
                  ),
                  20.verticalSpace,
                  Text(
                    context
                        .tr(LocaleKeys.app_userTypeSelection_thankYouMessage),
                    style: AppTextStyles.font16TextW500.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 40.h, // Adjust as needed
            child: AppElevatedButton(
              onPressed: () {
                // Navigate to HomePage
                context.router.push(const HomeRoute());
              },
              child: Text(context.tr(LocaleKeys.app_signup_login)),
            ),
          ),
        ],
      ),
    );
  }
}
