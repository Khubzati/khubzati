// ignore_for_file: deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khubzati/features/auth/presentation/widgets/progress_indicator.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/styles/app_text_style.dart';
import '../../../../core/widgets/app_bloc_wrapper_screen.dart';
import '../../../../gen/translations/locale_keys.g.dart';
import '../widgets/step_based_signup.dart';
import '../../../../core/widgets/custom_app_bar.dart';

@RoutePage()
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _currentStep = 0;
  final int _totalSteps = 3;

  void _onStepChanged(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBlocWrapperScreen(
      appBar: const CustomAppBar(
        title: LocaleKeys.app_auth_signup_title,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress Indicator
          SignupProgressIndicator(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: StepBasedSignup(
                onSignupComplete: (data) {
                  // Handle signup completion
                  print('Signup data: $data');
                  // TODO: Process signup data and navigate to next screen
                },
                onStepChanged: _onStepChanged,
              ),
            ),
          ),
          // Login link at bottom
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.app_auth_already_have_account_prompt.tr(),
                  style: AppTextStyles.font16textDarkBrownBold,
                ),
                TextButton(
                  onPressed: () {
                    context.router.push(const LoginRoute());
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                  ),
                  child: Text(
                    LocaleKeys.app_auth_login_link.tr(),
                    style: AppTextStyles.font16PrimaryBold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
