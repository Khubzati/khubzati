import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/styles/app_text_style.dart';
import '../../../../core/widgets/app_elevated_button.dart';
import '../../../../core/widgets/background_with_logo.dart';
import '../../../../gen/translations/locale_keys.g.dart';
import '../../../../core/di/injection.dart';
import '../../application/blocs/auth_bloc.dart';

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
            child: BlocBuilder<AuthBloc, AuthState>(
              bloc: getIt<AuthBloc>(),
              builder: (context, state) {
                // Enable button only when user is authenticated or OTP is verified
                final isVerified =
                    state is Authenticated || state is OtpVerified;
                final isLoading = state is AuthLoading;

                return AppElevatedButton(
                  onPressed: isVerified && !isLoading
                      ? () {
                          // Navigate to HomePage only if verified
                          context.router.push(MainNavigationRoute());
                        }
                      : null, // Disable button if not verified or loading
                  child: isLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(context.tr(LocaleKeys.app_signup_login)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
